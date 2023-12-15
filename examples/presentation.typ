 #import "@preview/polylux:0.3.1": *
#import "../template.typ": *

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

#ktu-main-slide[
    == Daug teksto

    #lorem(130)
]

#ktu-no-vertical-slide[
    == Daug teksto, kitas variantas

    #lorem(130)
]
