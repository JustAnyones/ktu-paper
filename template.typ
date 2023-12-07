// A template function to create a stylised report
#let ataskaita(
    title,
    subTitles,
    type: none,
    author: none,
    recipient: none,
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

    set heading(numbering: "1.")

    // Set bibliography and citing style
    set bibliography(style: "Assets/iso690-numeric-lt.csl")



    // Title page
    [
        // Top of the title page
        #v(20pt)
        #align(center)[
            #image("Assets/ktu.png", width: 2.46cm, height: 2.69cm)
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
        // TODO: support multiple authors and recipients
        #v(15pt)
        #align(left)[
            #h(300pt)*#author*
            #parbreak()
            #h(300pt)Studentas
            #v(12pt);
            #h(300pt)*#recipient*
            #parbreak()
            #h(300pt)Dėstytojas
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
