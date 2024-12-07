(defmodule PreguntasUsuario
    (import DataBase ?ALL)
    (import Templates ?ALL)
    (import TipoPregunta ?ALL)
    (export ?ALL)
)

;===================================================================================================;
;============================================== DATOS ==============================================;
;===================================================================================================;

; Leemos el nombre del usuario
(defrule preguntar-nombre
    ; Verificamos que la primera pregunta no haya sido respondida
    ?state <- (estado (primera_pregunta ?t)) (test (eq ?t TRUE))
    ?grupo <- (datos-grupo)
	=>
    (printout t "Introduzca su nombre: " crlf)
    (bind ?nombre (read))
    (modify ?grupo (nombre ?nombre))
    (retract ?state)
    (assert (estado (segunda_pregunta TRUE)))
    (printout t crlf)
)

; Preguntamos el tamaño del grupo
(defrule preguntar-tipo
    ?state <- (estado (segunda_pregunta ?t)) (test (eq ?t TRUE))
	?grupo <- (datos-grupo)
    =>
    (printout t "Selecciona el tamaño del grupo de visitantes:" crlf)
    (printout t "1. Una persona" crlf)
    (printout t "2. Una familia" crlf)
    (printout t "3. Un grupo pequeño (2-5 personas)" crlf)
    (printout t "4. Un grupo grande (>5 personas)" crlf)
    (bind ?opcion (pregunta-numerica "Elija una opción" 1 4))
    (bind ?tipo (nth$ ?opcion 
                (create$ "Persona" 
                         "Familia" 
                         "GrupoPequeno" 
                         "GrupoGrande"))
    )
    (modify ?grupo (tipo ?tipo))
    (retract ?state)
    (assert (estado (tercera_pregunta TRUE)))
    (printout t crlf)
)

; Preguntamos cuantos dias tiene planeado visitar el museo
(defrule preguntar-dias
    ?state <- (estado (tercera_pregunta ?t)) (test (eq ?t TRUE))
    ?grupo <- (datos-grupo)
    =>
    (printout t "¿Cuántos días desea visitar el museo?" crlf)
    (bind ?dias (pregunta-numerica "Ingrese el número de días" 1 7)) 
    (modify ?grupo (dias ?dias))
    (retract ?state)
    (assert (estado (cuarta_pregunta TRUE)))
    (printout t crlf)
)

; Preguntamos cuantas horas, como maximo, desea visitar el museo por dia
(defrule preguntar-horas
    ?state <- (estado (cuarta_pregunta ?t)) (test (eq ?t TRUE))
    ?grupo <- (datos-grupo)
    =>
    (printout t "¿Cuántas horas, como máximo, desea visitar el museo por día? (Introduzca un número entre 1 y 8)" crlf)
    (bind ?horas (pregunta-numerica "Ingrese el número de horas por día" 1 8)) 
    
    (modify ?grupo (horas ?horas))
    (retract ?state)
    (assert (estado (quinta_pregunta TRUE)))
    (printout t crlf)
)

; Determinamos el conocimiento del usuario en base a preguntas
(defrule preguntar-conocimiento
    ?state <- (estado (quinta_pregunta ?t)) (test (eq ?t TRUE))
    ?grupo <- (datos-grupo)
    =>
    (printout t "Por útimo, responda las siguientes preguntas:" crlf)
    (bind ?puntos 0)

    ; Primera pregunta
    (printout t "A) ¿Quién pintó 'La Última Cena'?" crlf)
    (printout t "   1. Leonardo da Vinci" crlf)
    (printout t "   2. Pablo Picasso" crlf)
    (printout t "   3. Vincent van Gogh" crlf)
    (printout t "   4. Claude Monet" crlf)
    (bind ?respuesta1 (pregunta-numerica "Elija una opción" 1 4))
    (if (eq ?respuesta1 1) then (bind ?puntos (+ ?puntos 1)))
    (printout t crlf)

    ; Segunda pregunta
    (printout t "B) ¿En qué periodo tuvo lugar el Renacimiento?" crlf)
    (printout t "   1. Siglo XIII" crlf)
    (printout t "   2. Siglo XIV al XVI" crlf)
    (printout t "   3. Siglo XVII" crlf)
    (printout t "   4. Siglo XVIII" crlf)
    (bind ?respuesta2 (pregunta-numerica "Elija una opción" 1 4))
    (if (eq ?respuesta2 2) then (bind ?puntos (+ ?puntos 1)))
    (printout t crlf)

    ; Tercera pregunta
    (printout t "C) ¿Qué características definen al arte barroco?" crlf)
    (printout t "   1. Simetría y simplicidad" crlf)
    (printout t "   2. Uso dramático de la luz y el movimiento" crlf)
    (printout t "   3. Representaciones abstractas" crlf)
    (printout t "   4. Colores pastel y escenas idílicas" crlf)
    (bind ?respuesta3 (pregunta-numerica "Elija una opción" 1 4))
    (if (eq ?respuesta3 2) then (bind ?puntos (+ ?puntos 1)))
    (printout t crlf)

    ; Cuarta pregunta
    (printout t "D) ¿Qué obra pintó Vincent van Gogh?" crlf)
    (printout t "   1. Las Meninas" crlf)
    (printout t "   2. La noche estrellada" crlf)
    (printout t "   3. El grito" crlf)
    (printout t "   4. La Gioconda" crlf)
    (bind ?respuesta4 (pregunta-numerica "Elija una opción" 1 4))
    (if (eq ?respuesta4 2) then (bind ?puntos (+ ?puntos 1)))
    (printout t crlf)

    ; Quinta pregunta
    (printout t "E) ¿Qué pintor es famoso por sus retratos de la corte española del siglo XVII?" crlf)
    (printout t "   1. Diego Velázquez" crlf)
    (printout t "   2. Sandro Botticelli" crlf)
    (printout t "   3. Rafael Sanzio" crlf)
    (printout t "   4. Pieter Bruegel el Viejo" crlf)
    (bind ?respuesta5 (pregunta-numerica "Elija una opción" 1 4))
    (if (eq ?respuesta5 1) then (bind ?puntos (+ ?puntos 1)))
    (printout t crlf)

    (printout t "Gracias por responder!" crlf)
    (modify ?grupo (conocimiento ?puntos))
    (retract ?state)
    (assert (estado (sexta_pregunta TRUE)))
    (printout t crlf)
)

;===================================================================================================;
;=========================================== PREFERENCIAS ==========================================;
;===================================================================================================;

; Preguntamos por los pintores favoritos del usuario
(defrule preguntar-pintor-favorito
    ?state <- (estado (sexta_pregunta ?t)) (test (eq ?t TRUE))
    =>
    (printout t "Seleccione a sus pintores favoritos de la lista. Ingrese los números separados por espacios si desea seleccionar varios:" crlf)
    
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
    
    (bind ?selecciones (pregunta-multiseleccion "Selecciona los autores por número separados por espacios"))

    (bind ?pintores-fav (create$))
    (foreach ?idx ?selecciones
        (bind ?pintores-fav (create$ ?pintores-fav (nth$ ?idx ?pintores)))
    )

    (assert (preferencias-grupo (pintores ?pintores-fav))) 
    ;(modify ?preferencias (pintores ?pintores-fav))
    (retract ?state)
    (assert (estado (septima_pregunta TRUE)))
)

; Preguntamos por las tematicas favoritas del usuario
(defrule pregunta-tematica-favorita
    ?state <- (estado (septima_pregunta ?t)) (test (eq ?t TRUE))
    ?preferencias <- (preferencias-grupo)
    =>
    (printout t "Seleccione sus temáticas favoritas de la lista. Ingrese los números separados por espacios si desea seleccionar varias:" crlf)
    
    (bind ?obras (find-all-instances ((?inst Cuadro)) TRUE))
    (bind ?tematicas (create$))
    (foreach ?obra ?obras
        (bind ?tematicas (create$ ?tematicas (send ?obra get-Tematica)))
    )
    (bind ?tematicas-unicas (remove-duplicates$ ?tematicas))

    (bind ?count 0)
    (foreach ?tematica ?tematicas-unicas
        (bind ?count (+ ?count 1))
        (printout t "   " ?count ". " ?tematica crlf)
    )

    (bind ?selecciones (pregunta-multiseleccion "Seleccione las temáticas por número separadas por espacios"))

    (bind ?tematicas-fav (create$))
    (foreach ?idx ?selecciones
        (bind ?tematicas-fav (create$ ?tematicas-fav (nth$ ?idx ?tematicas-unicas)))
    )

    (modify ?preferencias (tematicas ?tematicas-fav))
    (retract ?state)
    (assert (estado (octava_pregunta TRUE)))
)

; Preguntamos por los estilos favoritos del usuario
(defrule pregunta-estilo-favorito
    ?state <- (estado (octava_pregunta ?t)) (test (eq ?t TRUE))
    ?preferencias <- (preferencias-grupo)

    =>

    (bind ?obras (find-all-instances ((?inst Cuadro)) TRUE))
    (bind ?estilos (create$))
    (foreach ?obra ?obras
        (bind ?estilos (create$ ?estilos (send ?obra get-Estilo)))
    )
    (bind ?estilos-unicos (remove-duplicates$ ?estilos))

    (printout t "Seleccione los estilos favoritos de la lista. Ingrese los números separados por espacios si desea seleccionar varios:" crlf)
    
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

    (modify ?preferencias (estilos ?estilos-fav))
    (retract ?state)
    (assert (estado (novena_pregunta TRUE)))
)

; Preguntamos por las epocas favoritas del usuario
(defrule pregunta-epoca-favorita
    ?state <- (estado (novena_pregunta ?t)) (test (eq ?t TRUE))
    ?preferencias <- (preferencias-grupo)
    =>

    (bind ?obras (find-all-instances ((?inst Cuadro)) TRUE))
    (bind ?epocas (create$))
    (foreach ?obra ?obras
        (bind ?epocas (create$ ?epocas (send ?obra get-Epoca)))
    )
    (bind ?epocas-unicas (remove-duplicates$ ?epocas))

    (printout t "Seleccione las épocas favoritas de la lista. Ingrese los números separados por espacios si desea seleccionar varias:" crlf)
    
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

    (modify ?preferencias (epocas ?epocas-fav))
    (retract ?state)
    (focus MAIN)
)