#import "../template.typ": ataskaita, bibl

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

#lorem(400)

#lorem(300)

#pagebreak()

= Antraštė

== Subantraštė

#lorem(200)

== Subantraštė

#lorem(200)

#pagebreak()

#bibl("examples/bibl.yml")