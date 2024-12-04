(defmodule preguntas-preferencias
	(import main ?ALL)
    (import tipo-preguntas ?ALL)
	(import preguntas-visitantes deftemplate ?ALL)
	(export ?ALL)
)

(defrule pregunta_pintorFavorito "Preguntar por los pintores favoritos"
    (preguntasPreferencias1)
    ?pintores <- (find-all-instances-of-class Pintor) ; Obtiene todos los pintores
    =>
    (printout t "Por favor, seleccione los autores favoritos de la lista. Ingrese los números separados por espacios si desea seleccionar varios:" crlf)
    (foreach ?pintor (create$ ?pintores) ; Recorre los pintores para mostrar sus nombres
        (printout t "   " (+ 1 ?index) ". " (send ?pintor get Nombre) crlf)
    )
    (bind ?selecciones (pregunta-multiseleccion "Seleccione los autores por número separados por espacios"))
    (bind ?autores (create$ (foreach ?idx ?selecciones
                                     (nth$ ?idx ?pintores)))) ; Traduce los números a instancias
    (assert (preferencias_grupo (autores_favoritos ?autores)))
)

(defrule pregunta_tematicaFavorita "Preguntar temáticas favoritas"
    (declare (salience 3))
    ?obras <- (find-all-instances-of-class Cuadro) ; Obtiene todas las obras de arte
    ?pref-grupo <- (preferencias_grupo) ; Encuentra el hecho de preferencias_grupo
    =>
    (bind ?tematicas (create$ (foreach ?obra ?obras (send ?obra get Tematica)))) 
    (bind ?tematicas-unicas (remove-duplicates$ ?tematicas)) ; Eliminar duplicados

    (printout t "Por favor, seleccione las temáticas favoritas de la lista. Ingrese los números separados por espacios si desea seleccionar varias:" crlf)
    (foreach ?tematica ?tematicas-unicas
        (printout t "   " (+ 1 ?index) ". " ?tematica crlf)
    )

    (bind ?selecciones (pregunta-multiseleccion "Seleccione las temáticas por número separadas por espacios"))
    (bind ?tematicas-fav (create$ (foreach ?idx ?selecciones
                                           (nth$ ?idx ?tematicas-unicas)))) ; Traduce los números a temáticas

    (modify ?pref-grupo (tematicas_obras_fav ?tematicas-fav))
)

(defrule pregunta_estiloFavorito "Preguntar estilos favoritos"
    (declare (salience 2))
    ?obras <- (find-all-instances-of-class Cuadro) ; Obtiene todas las obras de arte
    ?pref-grupo <- (preferencias_grupo) ; Encuentra el hecho de preferencias_grupo
    =>
    (bind ?estilos (create$ (foreach ?obra ?obras (send ?obra get Estilo)))) 
    (bind ?estilos-unicos (remove-duplicates$ ?estilos)) ; Eliminar duplicados

    (printout t "Por favor, seleccione los estilos favoritos de la lista. Ingrese los números separados por espacios si desea seleccionar varios:" crlf)
    (foreach ?estilo ?estilos-unicos
        (printout t "   " (+ 1 ?index) ". " ?estilo crlf)
    )

    (bind ?selecciones (pregunta-multiseleccion "Seleccione los estilos por número separados por espacios"))
    (bind ?estilos-fav (create$ (foreach ?idx ?selecciones
                                         (nth$ ?idx ?estilos-unicos)))) ; Traduce los números a estilos

    (modify ?pref-grupo (estilos_favoritos ?estilos-fav))
)

(defrule pregunta_epocaFavorita "Preguntar épocas favoritas"
    (declare (salience 1))
    ?obras <- (find-all-instances-of-class Cuadro) ; Obtiene todas las obras de arte
    ?pref-grupo <- (preferencias_grupo) ; Encuentra el hecho de preferencias_grupo
    =>
    (bind ?epocas (create$ (foreach ?obra ?obras (send ?obra get Epoca)))) 
    (bind ?epocas-unicas (remove-duplicates$ ?epocas)) ; Eliminar duplicados

    (printout t "Por favor, seleccione las épocas favoritas de la lista. Ingrese los números separados por espacios si desea seleccionar varias:" crlf)
    (foreach ?epoca ?epocas-unicas
        (printout t "   " (+ 1 ?index) ". " ?epoca crlf)
    )

    (bind ?selecciones (pregunta-multiseleccion "Seleccione las épocas por número separados por espacios"))
    (bind ?epocas-fav (create$ (foreach ?idx ?selecciones
                                        (nth$ ?idx ?epocas-unicas)))) ; Traduce los números a épocas

    (modify ?pref-grupo (epocas_favoritas ?epocas-fav))
)