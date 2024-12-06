(defmodule preguntas-preferencias (import templates ?ALL) (import tipoPregunta ?ALL) (import DataBase ?ALL) (export ?ALL))

(defrule pregunta_pintorFavorito "Preguntar por los pintores favoritos"
    ?state <- (estado (sexta_pregunta ?t)) 
    (test (eq ?t TRUE))
    =>
    (printout t "Por favor, seleccione los autores favoritos de la lista. Ingrese los números separados por espacios si desea seleccionar varios:" crlf)
    
    (bind ?pintores_raw (find-all-instances ((?inst Pintor)) TRUE))
    (bind ?pintores (create$))
    (foreach ?pintor ?pintores_raw
        (bind ?pintores (create$ ?pintores (send ?pintor get-Nombre)))
    )

    (bind ?count 0)
    (foreach ?autor ?pintores
        (bind ?count (+ ?count 1))
        (printout t "   " ?count ". " ?autor crlf)
    )
    
    (bind ?selecciones (pregunta-multiseleccion "Seleccione los autores por número separados por espacios"))

    (bind ?pintores-fav (create$))
    (foreach ?idx ?selecciones
        (bind ?pintores-fav (create$ ?pintores-fav (nth$ ?idx ?pintores)))
    )

    (assert (preferencias_grupo (pintores_favoritos ?pintores-fav))) 
    ;(modify ?preferencias (pintores_favoritos ?pintores-fav))
    (retract ?state)
    (assert (estado (septima_pregunta TRUE)))
)

(defrule pregunta_tematicaFavorita "Preguntar temáticas favoritas"
    ?state <- (estado (septima_pregunta ?t)) 
    (test (eq ?t TRUE))
    ?preferencias <- (preferencias_grupo)             ; Encuentra el hecho de preferencias_grupo
    =>
    (printout t "Por favor, seleccione las temáticas favoritas de la lista. Ingrese los números separados por espacios si desea seleccionar varias:" crlf)
    
    (bind ?obras (find-all-instances ((?inst Cuadro)) TRUE))
    (bind ?tematicas (create$))
    (foreach ?obra ?obras
        (bind ?tematicas (create$ ?tematicas (send ?obra get-Tematica)))
    )
    (bind ?tematicas-unicas (remove-duplicates$ ?tematicas)) ; Eliminar duplicados

    (bind ?count 0)
    (foreach ?tematica ?tematicas-unicas
        (bind ?count (+ ?count 1))
        (printout t "   " ?count ". " ?tematica crlf)
    )

    (bind ?selecciones (pregunta-multiseleccion "Seleccione las temáticas por número separadas por espacios"))

    ; Construimos ?tematicas-fav según las selecciones
    (bind ?tematicas-fav (create$))
    (foreach ?idx ?selecciones
        (bind ?tematicas-fav (create$ ?tematicas-fav (nth$ ?idx ?tematicas-unicas)))
    )

    (modify ?preferencias (tematicas_favoritas ?tematicas-fav))
    (retract ?state)
    (assert (estado (octava_pregunta TRUE)))
)

(defrule pregunta_estiloFavorito "Preguntar estilos favoritos"
    ?state <- (estado (octava_pregunta ?t)) 
    (test (eq ?t TRUE))
    ?preferencias <- (preferencias_grupo)
    =>

    (bind ?obras (find-all-instances ((?inst Cuadro)) TRUE))
    (bind ?estilos (create$))
    (foreach ?obra ?obras
        (bind ?estilos (create$ ?estilos (send ?obra get-Estilo)))
    )
    (bind ?estilos-unicos (remove-duplicates$ ?estilos))

    (printout t "Por favor, seleccione los estilos favoritos de la lista. Ingrese los números separados por espacios si desea seleccionar varios:" crlf)
    
    (bind ?count 0)
    (foreach ?estilo ?estilos-unicos
        (bind ?count (+ ?count 1))
        (printout t "   " ?count ". " ?estilo crlf)
    )

    (bind ?selecciones (pregunta-multiseleccion "Seleccione los estilos por número separados por espacios"))

    (bind ?estilos-fav (create$))
    (foreach ?idx ?selecciones
        (bind ?estilos-fav (create$ ?estilos-fav (nth$ ?idx ?estilos-unicos)))
    )

    (modify ?preferencias (estilos_favoritos ?estilos-fav))
    (retract ?state)
    (assert (estado (novena_pregunta TRUE)))
)

(defrule pregunta_epocaFavorita "Preguntar épocas favoritas"
    ?state <- (estado (novena_pregunta ?t)) 
    (test (eq ?t TRUE))
    ?preferencias <- (preferencias_grupo)
    =>

    (bind ?obras (find-all-instances ((?inst Cuadro)) TRUE))
    (bind ?epocas (create$))
    (foreach ?obra ?obras
        (bind ?epocas (create$ ?epocas (send ?obra get-Epoca)))
    )
    (bind ?epocas-unicas (remove-duplicates$ ?epocas))

    (printout t "Por favor, seleccione las épocas favoritas de la lista. Ingrese los números separados por espacios si desea seleccionar varias:" crlf)
    
    (bind ?count 0)
    (foreach ?epoca ?epocas-unicas
        (bind ?count (+ ?count 1))
        (printout t "   " ?count ". " ?epoca crlf)
    )

    (bind ?selecciones (pregunta-multiseleccion "Seleccione las épocas por número separados por espacios"))

    (bind ?epocas-fav (create$))
    (foreach ?idx ?selecciones
        (bind ?epocas-fav (create$ ?epocas-fav (nth$ ?idx ?epocas-unicas)))
    )

    (modify ?preferencias (epocas_favoritas ?epocas-fav))
    (retract ?state)
    (focus MAIN)
)