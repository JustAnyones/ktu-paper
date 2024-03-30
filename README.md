# KTU-Typst

This repository contains a Typst template for KTU style presentation and written work.

To use the template, just import `template.typ` at the top of the Typst document and apply a show rule.

## Report

The following is an example on how to apply the report style for a document

```typst
#import "template.typ": ataskaita

#show: ataskaita.with(
    "Kompiuterinis raštingumas",
    (
        [Technologinis projektas],
        [Typst šablonas]
    ),
    authors: ("Vardenis Pavardenis",),
    recipients: (
        "lekt. Petras Petraitis",
    ),
    authorRole: "Studentas",
    recipientRole: "Dėstytojas"
)

= Įvadas
...
```

## Presentation

For presentations, we use the Polylux Typst package. I suggest that you consult documentation on how it works before proceeding.

```typst
#import "@preview/polylux:0.3.1": *
#import "template.typ": *

#show: everything => ktu-theme(everything)

#ktu-title-slide[
    = Pristatymo tema

    #box[
        #set text(size: 18pt)
        Autoriai: Vardenis Pavardenis, Petras Petraitis
    ]
]

#ktu-outline-slide[
    == Turinys

    1. Įvadas
    2. Dėstymas
    3. Išvados
]

#ktu-main-slide[
    == Įvadas

    ...
]

...
```
### Options

- `#ktu-title-slide` for first, title slide
- `#ktu-outline-slide` for second, outline slide
- `#ktu-main-slide` main content slide
- `#ktu-no-vertical-slide` main content slide without a vertical line on the right
