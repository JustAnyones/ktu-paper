#import "@preview/codly:1.3.0": codly, codly-init
#import "config.typ": debug-author-table, enable-heading-experiment, __HEADING_EXPERIMENT
#import "fragments.typ": (
    ktu-table,
    ktu-heading-page-centered, ktu-heading-page-normal, ktu-academic-honestly-declaration-page
)

/**
 * Paruošta pagal "Rašto ..."
*/

/*
 * Further reading required:
 * - Double line spacing | https://github.com/typst/typst/issues/106
 * - Proposal: change `leading` option to `line-height` | https://github.com/typst/typst/issues/4224
*/

/// 
/// Insert a heading without a number.
/// 
/// Usually used for introductory or summary sections at the start and end.
/// - text (str): The heading's title.
/// -> 
#let unnumbered-heading(text) = {
    set heading(numbering: none)
    [#text]
}

#let figureDefinitions = (
    table: (
        outlineFormat: (number) => [*#number lentelė.*],
        captionFormat: (number) => [*#number lentelė.*],
    ),
)

#let custom-figure(
    kind,
    caption: none,
    body
) = {
    figure(
        body,
        kind: kind,
        caption: caption,
        supplement: "CUSTOM-FIGURE"
    )
}

#let appendix-item(body) = {
    heading(
        metadata("appendix-heading") + "priedas. " + body,
        level: 2,
        numbering: (..any) => {str(any.at(1))}
    )
}

// Stores localized names for various figure types
#let figureNames = (
    table: ("lentelė"),
    image: ("pav"),
    code: ("kodo frag"),
    equation: ("lygtis"),
)

// Utility function to round numbers with padded zeros
#let round-and-pad(number, decimals) = {
  let rounded = calc.round(number, digits: decimals)
  let s = str(rounded)
  let parts = s.split(".")
  let integer-part = parts.at(0)
  let decimal-part = if parts.len() == 2 { parts.at(1) } else { ""}


  let padded-decimal = if decimals > 0 {
    let current-decimal-length = decimal-part.len()
    let padding-needed = decimals - current-decimal-length
    let trailing-zeros = ""
    for _ in range(padding-needed) {
      trailing-zeros = trailing-zeros + "0"
    }
    if decimal-part == "" {
      "." + trailing-zeros
    } else {
      "." + decimal-part + trailing-zeros
    }.slice(0, decimals + 1)
  } else {
    ""
  }
  integer-part + padded-decimal
}


/// Returns a number for the given reference target.
/// - target (label): Label to get the reference number for.
#let ref-no(target) = context {
    let loc = locate(target)
    let elem = query(target)
    let item = elem.at(0)
    
    // If it's a figure, return the figure number
    if item.func() == figure {
        link(loc, [#counter(figure.where(kind: item.kind)).at(loc).at(0)])
    } else if item.func() == heading {
        let fullValue = counter(heading).at(loc)

        // If the heading has the "appendix-heading" metadata attached,
        // it means that it's an appendix heading and should be numbered differently
        if item.body.has("children") and item.body.children.at(0) == metadata("appendix-heading") {
            link(loc, [#fullValue.at(1)])
        // Otherwise, show the fully qualified heading numbering
        } else {
            link(loc, [#fullValue.map((x) => str(x)).join(".")])
        }
    } else {
        panic("referencing unknown type: ", item.func())
    }
}

#let __ref-no-element(element) = context {
    // Ensure that we pass an element
    if type(element) != content {
        panic("can only reference elements of type content")
    }
    let loc = element.location()
    let elem = query(loc)
    let fig = elem.at(0)
    if fig.func() != figure {
        panic("referencing unknown type: " + fig.func())
    }
    fig.caption.counter.at(loc).at(0)
}

// Constructs a reference from multiple targets
#let custom-ref(..targets) = context {
  let collected = (:)

  for target in targets.pos() {
    let loc = locate(target)
    let elem = query(target)

    let fig = elem.at(0)
    if fig.func() != figure {
      panic("referencing unknown type")
    }

    // determine what we...
    let element = fig.body;
    let elementName = "unknown";
    let found = false;
    while not found {

      // If it's a grid
      if (element.func() == grid) {
        for cell in element.children {
          if cell.body.func() == image {
            elementName = "pav."
            found = true
            break
          }
        }
        break
      }

      if (element.func() == table) {
        elementName = "lentelė"
        found = true
        break
      }

    if (element.func() == raw) {
        elementName = "kodo frag."
        found = true
        break
      }

      if (element.func() == image) {
        elementName = "pav."
        found = true
        break
      }

      panic("unknown element", element.func())
    }

    if elementName not in collected {
      collected.insert(elementName, ())
    }

    collected.at(elementName).push(
      (loc, fig.caption.counter.at(loc).at(0))
    )
  }

  if collected.len() > 1 {
    panic("multiple types detected")
  }

  for type in collected {
    let name = type.at(0)
    let arr = type.at(1).sorted(key: k => k.at(1))

    [(žr. #arr.map(x =>link(x.at(0), [#x.at(1)])).join(", ") #name)]
  }
}


/// Returns a KTU template-conformant outline.
/// - depth (int | none): Same as outline depth.
/// - indent (auto | function | relative): Same as outline indent.
/// - target (function | label | location | selector): Same as outline target.
/// - title (auto | content | none): Same as outline title.
/// -> outline
#let __ktu_outline(
    depth: none,
    indent: 0em, // Disable the default outline indenting
    target: heading,
    title: auto
) = {
    // TODO: įtrauka
    set block(spacing: 0em)
    // genius solution by @two_horus on Discord (364397430059302912)
    show outline: o => context {
        // If it's a heading, show the default outline with bold text
        if (o.target == selector(heading)) {
            // Define known target widths based on KTU template
            let targets = (0.64cm, 0.96cm, 1.28cm, 1.6cm, 1.92cm)
            
            // Apply custom outline entry formatting
            show outline.entry: it => {
                // Recompute the gap based on the prefix content, so that the outline entry is indented
                // from the left regardless of the length of the prefix (based on the requirement)
                let prefixContent = it.prefix()
                let measurement = measure(prefixContent)
                let target = targets.at(it.level - 1, default: 0.64cm)
                let newGap = target - measurement.width
                if it.element.body.has("children") and it.element.body.children.at(0) == metadata("appendix-heading") {
                    target = 0.64cm
                }
                let newGap = target - measurement.width
                link(
                    it.element.location(),
                    it.indented(prefixContent, it.inner(), gap: newGap),
                )
            }

            show outline.entry.where(level: 1): e => {
                strong(e)
            }
            o

        // If it's an image
        } else if (o.target == figure.where(kind: image)) {
            show outline.entry: it => link(
                it.element.location(),
                it.indented([*#__ref-no-element(it.element) #figureNames.image.*], [ #it.inner()], gap: 0pt),
            )
            o

        // If it is a table, show table formatting
        } else if (o.target == figure.where(kind: table)) {
            show outline.entry: it => link(
                it.element.location(),
                it.indented([*#__ref-no-element(it.element) #figureNames.table.*], [ #it.inner()], gap: 0pt),
            )
            o

        // If it is a table, show table formatting
        } else if (o.target == figure.where(kind: raw)) {
            show outline.entry: it => link(
                it.element.location(),
                it.indented([*#__ref-no-element(it.element) #figureNames.code.*], [ #it.inner()], gap: 0pt),
            )
            o

        // Otherwise, try to determine what kind of outline it is
        } else {

            /*[
                #o.target #type(o.target),
                #(o.target == "heading")
                #(o.target == heading)
                #(o.target == figure.where(kind: heading))
                #(o.target == heading.where())
                #(o.target == selector(heading))
            ]*/

            show outline.entry: it => link(
                it.element.location(),
                it.indented([*#__ref-no-element(it.element) unknown.*], it.inner(), gap: 0pt),
            )
            o
        }
    }
    outline(depth: depth, indent: indent, target: target, title: title)
}

#let func-to-name(func) = {
    if func == table {
        return "lentelė"
    }
    if func == image {
        return "pav."
    }
    if func == grid {
        return "pav."
    }
    return func
}

// Doesn't work in Typst 0.12.0 due to relative paths
#let bibliography-list(path) = {
    bibliography(path, title: "Literatūros sąrašas", full: true) 
}

/// Returns a KTU style conformant outline.
/// - depth (int | none): Same as outline depth.
/// - indent (auto | function | relative): Same as outline indent.
/// - target (function | label | location | selector): Same as outline target.
/// - title (auto | content | none): Same as outline title.
/// -> outline
#let ktu-outline(
    depth: none,
    indent: 0em, // Disable the default outline indenting
    target: heading,
    title: auto
) = {
    __ktu_outline(depth: depth, indent: indent, target: target, title: title)
}

#let ktu-table-of-contents(depth: 3) = {
    ktu-outline(target: heading, title: "Turinys", depth: depth)
}

#let ktu-table-list() = {
    ktu-outline(title: heading("Lentelių sąrašas", outlined: true), target: figure.where(kind: table))
}

#let ktu-picture-list() = {
    ktu-outline(title: heading("Paveikslų sąrašas", outlined: true), target: figure.where(kind: image))
}

/// Define a custom outline for a specific figure type.
/// This function creates an outline entry with a specified title and figure type.
/// The outline entry will link to the figure of the specified type.
/// - title (str): Title of the outline
/// - kind (str): Type of the figure
#let custom-list(title, kind) = {
    __ktu_outline(title: heading(title, outlined: true), target: figure.where(kind: kind))
}

#let setup-code(body) = {
    show: codly-init.with()
    codly(
        fill: white,
        zebra-fill: none,
        stroke: none,
        display-name: false,
        display-icon: false,
    )
    show raw: set text(font: "Hack", spacing: 80%)
    body
}

#let __page_rules(body) = {
    // Page size and margins
    set page(
        paper: "a4",
        width: 210mm,
        height: 297mm,
        margin: (
            left: 30mm,
            right: 10mm,
            bottom: 20mm,
            top: 20mm
        )
    )
    set page(width: 595pt, height: 842pt)

    // Numbering rules
    set page(numbering: none, number-align: right)

    // Use Lithuanian quotes
    set smartquote(quotes: "„“")

    // Heading numbering
    set heading(numbering: "1.")

    // Number equations
    set math.equation(numbering: "(1)")

    // Set text font
    set text(
        font: "Arial",
        size: 12pt,
        lang: "lt",
        // Change where the bounding box is drawn for the text
        top-edge: "ascender",
        bottom-edge: "descender",
        kerning: false, // Disable kerning
    )

    // Text line interval, defined differently in Typst
    let leading = 1.15em // Your line spacing (1, 1.5, 2, etc.)
    let leading = leading - 0.75em // "Normalization"
    set par(leading: leading)

    // Indentation for lists and enumerations
    set enum(indent: 12pt)
    set list(indent: 12pt)

    body
}

#let setup-page(body) = {
    show: __page_rules.with()

    // Pagal formaliuosius rašto darbų reikalavimus

    // Tarpas tarp teksto pastraipų
    set par(spacing: 10pt)
    set block(below: 10pt)

    // Teksto lygiuotė, abipusė
    set par(justify: true)
    set linebreak(justify: true)

    // Antraštės
    // Force them into blocks so they don't count as paragraphs
    show heading: it => {
        // Align everything left
        set align(left)

        // Visų antraščių teksto dydis vienodas
        // Visų antraščių teksto šifras paryškintas
        set text(size: 12pt)
        set block(below: 10pt)

        let useExperiment = __HEADING_EXPERIMENT.get()

        // TODO: intervalas tarp eilučių – 1,15 kiekvienai antraštei

        // Antraštė be nr.
        if it.numbering == none {
            // Centruota lygiuotė
            set align(center)

            // atstumas prieš ir po antraštės - 10 pt
            block[#it.body]
            if useExperiment {
                v(10pt)
            }
        }


        // Skyrius
        if it.numbering != none and it.level == 1 {
            // abipusė lygiuotė
            set par(justify: true)
            //set align

            // po antraštės - 10 pt
            block[#counter(heading).display() #it.body]
            if useExperiment {
                v(10pt)
            }
        }

        // Determine whether the heading has appending metadata attached and adjust its display accordingly
        let isAppendixHeading = it.body.has("children") and it.body.children.at(0) == metadata("appendix-heading")
        if isAppendixHeading {
            block[#counter(heading).display(it.numbering) #it.body]
        }

        // Poskyris ir skyrelis
        if not isAppendixHeading and it.numbering != none and it.level != 1 {
            // abipusė lygiuotė
            set par(justify: true)

            // prieš ir po antraštės - 10 pt
            if useExperiment {
                v(10pt)
            }
            block[#counter(heading).display() #it.body]
            if useExperiment {
                v(10pt)
            }
        }
    }

    // Override references for equations
    show ref: it => {
        let el = it.element

        if el == none {
            return it
        }

        // Override equation references
        if el.func() == math.equation {
            link(
                el.location(),
                numbering(el.numbering, ..counter(math.equation).at(el.location()))
            )
        // Override references to figures
        } else if el.func() == figure {
            let fig = el.body
            let figType = fig.func()
            link(el.location(), [
                (žr. #numbering(el.numbering, ..counter(figure.where(kind: figType)).at(el.location())) #func-to-name(figType))
            ])
        } else {
            it
        }
    }

    // Change captions for figures
    show figure: it => {
        let separator = [.]
        let caption = it.caption

        // If caption is not provided, just show the figure body
        if caption == none {
            it.body
            return
        }

        let counter = caption.counter  
        let supplement = caption.supplement

        if it.body.func() == math.equation {
            supplement = figureNames.equation
        } else if it.kind == image {
            supplement = figureNames.image
        } else if it.kind == table {
            supplement = figureNames.table
        } else if it.kind == raw {
            supplement = figureNames.code
        }


        // Tables have captions at the top
        set text(size: 11pt)
        if it.kind == table {
            {set align(left)
            [*#context counter.display(caption.numbering) #supplement#separator* #caption.body]}
            it.body
        } else {
            it.body
            [*#context counter.display(caption.numbering) #supplement#separator* #caption.body]
        }
    }

    // Lentelės pirma eilutė
    /*
    show table.cell.where(y: 0): it => context {
        set align(left)
        set par(justify: false)
        set text(size: TableHeadSize.get()) // Šrifto dydis
        v(3pt)
        // Paryškintas
        [*#it*]
        v(3pt)
    }

    show table.cell: it => context {
        set align(left)
        set par(justify: false)
        set text(size: TableCellSize.get())
        v(3pt)
        [#it]
        v(3pt)
    }*/

    // Set bibliography and citing style
    set bibliography(style: "assets/iso690-numeric-lt.csl")

    // Return the body
    body
}

