// A template function to create a stylised report
#let ataskaita(
    title,
    subTitles,
    type: none,
    authors: none,
    recipients: none,
    recipientRole: none,
    authorRole: none,
    document: none
) = {

    // Setup page properties
    set page(
        paper: "a4",
        width: 210mm,
        height: 297mm,
        numbering: none,
        number-align: right,
        margin: (
            right: 10mm,
            left: 30mm,
            bottom: 20mm,
            top: 20mm
        )
    )

    set par(
        leading: 1.15em
    )

    set par(
        leading: 6pt
    )

    show: all => [
        #set text(
            font: "Times New Roman",
            size: 12pt,
            style: "normal",
            weight: "regular",
            spacing: 200%
        )
        #all
    ]

    // Nustatom visus paragrafus
    show heading: it => [
        #set align(left)
        #set text(
            font: "Times New Roman",
            size: 12pt
        )   
        #counter(heading).display() #it.body
        #v(0.35cm)
    ]

    show heading.where(numbering: none): it => [
        #set align(center)
        #set text(
            font: "Times New Roman",
            size: 12pt
        )   
        #it.body
    ];

    // Setup figures
    set figure.caption(separator: [.])
    show figure.caption: it => [
        #let supplement = it.supplement
        #if it.kind == image {
            supplement = "pav"
        }
        #it.counter.display(it.numbering) #supplement#it.separator #it.body
    ]

    set heading(numbering: "1.")

    // Set bibliography and citing style
    set bibliography(style: "Assets/iso690-numeric-lt.csl")



    // Title page
    [
        // Top of the title page
        #v(20pt)
        #align(center)[
            #image("Assets/ktu-logo.png", width: 2.46cm, height: 2.69cm)
            #v(20pt)*Kauno technologijos universitetas*
            #v(0pt)Informatikos fakultetas
            #v(83pt)
        ]

        // The title page information
        #align(center)[
            #text(size: 18pt)[*#title*]
            #for subTitle in subTitles {
                [
                    #v(-5pt)
                    #text(size: 14pt)[#subTitle]
                ]
            }
            #v(100pt)
        ]

        // Written by and intended for
        // TODO: support multiple authors
        #v(15pt)
        #align(left)[
            #for author in authors {
                [
                    //#v(-5pt)
                    #h(300pt)*#author*
                    #parbreak()
                ]
            }
            #h(300pt)#authorRole
            #v(12pt)
            #for recipient in recipients {
                [
                    //#v(-5pt)
                    #h(300pt)*#recipient*
                    #parbreak()
                ]
            }
            #parbreak()
            #h(300pt)#recipientRole
        ]

        // Footer of place where it was written and year
        #align(center+bottom)[
            *Kaunas, #datetime.today().year()*
        ]

        #pagebreak()

        // Begin numbering from the outline
        #set page(
            numbering: "1"
        )

        #outline(
            title: "Turinys"
        )

        #pagebreak()

        #document
  ]
}

// Bibliography shorthand
#let bibl(path) = {
    [
        #bibliography(
            path,
            title: "Literatūros sąrašas",
            full: true
        ) 
    ]
}





















// PRESENTATION
#import "@preview/polylux:0.3.1": *

// The margins are set automatically to 2.5/21 times the smaller dimension of the page. This results in 2.5cm margins for an A4 page.
#let autoMarginSize = 2.5/21 * 7.50in
#let margins = (
    top: autoMarginSize,
    right: autoMarginSize,
    left: autoMarginSize,
    bottom: autoMarginSize
);

#let ktu-theme(body) = {

    set page(
        fill: white,
        numbering: "1",
        number-align: right,
        width: 13.33in,
        height: 7.50in,
        margin: margins,
        footer: {
            locate(loc => {
                let page-counter = counter(page).display("1")
                if loc.page() != 1 {
                    place(bottom+right, dx: 18pt, dy: -20pt)[
                        #set text(size: 14pt)
                        *#page-counter*
                    ]
                }
            })
        }
    )
    
    // Default content size
    set text(size: 22pt, font: "Arial")

    // First level heading size
    show heading.where(level: 1): it => [
        #set text(size: 50pt)
        #it.body
    ];

    // Second level heading size
    show heading.where(level: 2): it => [
        #set text(size: 30pt)
        #it.body
    ];

    // Embed the body
    body
}

#let ktu-title-slide(body) = {
    polylux-slide[
        // Content
        #set align(bottom)
        #box(width: 80%)[
            #body
        ]


        // Horizontal line
        #place(
            top,
            dx: 222pt,
            dy: -200pt,
            pad(
                right: -margins.right + 100pt,
                left: -margins.left,
                scale(
                    x: 300%,
                    rotate(
                        -90deg,
                        image("Assets/image12.svg") 
                    )
                )
            )
        )

        /*
        #place(
            top,
            dx: 190pt,
            //dy: -200pt,
            dy: -88pt,
            pad(
                //right: -margins.right + 100pt,
                //left: -margins.left,
                scale(
                    y: 10%,
                    x: 10%,
                    image("Assets/image4.svg") 
                )
            )
        )
        */

        // KTU logo
        #place(
            top,
            dx: 792pt,
            dy: -40pt,
            image("Assets/ktu-logo.png", height: 36mm)
        )

        // Vertical line
        #place(
            top,
            dx: 360pt,
            dy: 385pt,
            pad(
                top: -margins.top,
                bottom: -margins.bottom,
                rotate(
                    -90deg,
                    scale(
                        y: -100%,
                        image("Assets/image15.svg")
                    )
                )
            )
        )

        // Text on the vertical line side
        #place(top, dx: 670pt, dy: 250pt)[
            #set text(size: 15pt)
            #rotate(-90deg)[
                *UŽ KIEKVIENOS TECHNOLOGIJOS – ŽMOGUS*
            ]
        ]
    ]
}

#let ktu-outline-slide(body) = {
    polylux-slide[
        // Content
        #box(
            pad(
                left: 90pt,
                body
            )
        )

        // KTU logo
        #place(
            top,
            //dx: 792pt,
            dx: -50pt,
            dy: -40pt,
            image("Assets/ktu-logo.png", height: 36mm)
        )

        // Vertical line
        #place(
            top,
            dx: -360pt,
            dy: 385pt,
            pad(
                top: -margins.top,
                bottom: -margins.bottom,
                rotate(
                    90deg,
                    scale(
                        y: -100%,
                        x: -100%,
                        image("Assets/image15.svg")
                    )
                )
            )
        )

        // Text on the vertical line side
        #place(top, dx: -170pt, dy: 250pt)[
            #set text(size: 15pt)
            #rotate(-90deg)[
                *UŽ KIEKVIENOS TECHNOLOGIJOS – ŽMOGUS*
            ]
        ]
    ]
}

#let ktu-main-slide(body) = {
    let header = body.children.find(it => { return it.func() == heading })

    polylux-slide[
        // Content
        #block(width: 95%, height: 100%)[
            #header
            #v(36pt)
            #body.children.filter(it => {return it.func() != heading}).join()
        ]

        // DECORATIONS
        // Horizontal line
        #place(
            top,
            dy: 44pt,
            pad(
                right: -margins.right + 94pt,
                left: -margins.left,
                image("Assets/image15.svg") 
            )
        )

        // KTU logo
        #place(
            top,
            dx: 820pt,
            dy: 0pt,
            image("Assets/ktu-text.svg", height: 10mm)
        )

        // Vertical line
        #place(
            top,
            dx: 800pt,
            pad(
                top: -margins.top,
                bottom: -margins.bottom,
                image("Assets/image12.svg")
            )
        )

        // Text on the vertical line side
        #place(top, dx: 700pt, dy: 250pt)[
            #set text(size: 13pt)
            #rotate(-90deg)[
                *UŽ KIEKVIENOS TECHNOLOGIJOS – ŽMOGUS*
            ]
        ]
    ]
}

#let ktu-no-vertical-slide(body) = {
    let header = body.children.find(it => { return it.func() == heading })

    polylux-slide[
        // Content
        #block(width: 100%, height: 100%)[
            #header
            #v(36pt)
            #body.children.filter(it => {return it.func() != heading}).join()
        ]

        // DECORATIONS
        // Horizontal line
        #place(
            top,
            dy: 1.52cm,
            pad(
                right: -margins.right,
                left: -margins.left,
                image("Assets/image15.svg") 
            )
        )

        // KTU logo
        #place(
            top,
            dx: 820pt,
            dy: 0pt,
            image("Assets/ktu-text.svg", height: 10mm)
        )
    ]
}
