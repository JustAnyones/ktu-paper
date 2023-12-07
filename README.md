# KTU-Typst

To use the template

```typst
#import "template.typ": ataskaita

#show: doc => ataskaita(
    "Kompiuterinis raštingumas",
    (
        [Technologinis projektas],
        [Typst šablonas]
    ),
    author: "Vardenis Pavardenis",
    recipient: "lekt. Petras Petraitis",
    document: doc,
)

= Įvadas
...
```
