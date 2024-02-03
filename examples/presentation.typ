#import "@preview/polylux:0.3.1": *
#import "@preview/codly:0.2.0": *
#import "@preview/pinit:0.1.3": *
#import "../template.typ": *

#show: everything => ktu-theme(everything)
#show: codly-init.with()
#codly(
    fill: luma(240),
    zebra-color: luma(240),

    display-name: false,
    display-icon: false,
    enable-numbers: false,
    stroke-width: 2pt,
    stroke-color: black
)

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

    #lorem(60)
]

#ktu-main-slide[
    == Daug teksto

    #lorem(130)
]

#ktu-no-vertical-slide[
    == Daug teksto, kitas variantas

    #only((1,2))[Būti]#only(2)[, ar nebūti]?

    #lorem(120)
]

#ktu-no-vertical-slide[
    == Kodas 1
    
    #text(size:15pt)[
    ```python
    import sys
    import signal
    import warnings

    from analyser.app import App
    from analyser.qt_compat import QtWidgets
    from analyser.settings import Settings

    signal.signal(signal.SIGINT, signal.SIG_DFL)
    warnings.filterwarnings("ignore", category=DeprecationWarning) 

    if __name__ == "__main__":
        settings = Settings()
        app = QtWidgets.QApplication(sys.argv)
        ex = App(settings)
        sys.excepthook = ex.excepthook
        sys.exit(app.exec_())
    ```]
]


#ktu-no-vertical-slide[
    == Kodas 2

    ```java
    public interface SortedSet<E> extends Set<E> {
        // Grąžinamas aibės poaibis iki element.
        Set<E> headSet(E element);
        // Grąžinamas aibės poaibis nuo element1 iki element2.
        Set<E> subSet(E element1, E element2);
        // Grąžinamas aibės poaibis nuo element.
        Set<E> tailSet(E element);
        // Grąžinamas atvirkštinis iteratorius.
        Iterator<E> descendingIterator();
    }
    ```

    #only(2)[
        #place(
            top+left,
            dx: 600pt, dy: 200pt
        )[#pin("test")]

        #pinit-point-from(
            pin-dx: -240pt,
            pin-dy: -90pt,
            "test",
            [Ką tai reiškia?]
        )
    ]
]
