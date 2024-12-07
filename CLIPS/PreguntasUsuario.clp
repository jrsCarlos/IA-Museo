(defmodule PreguntasUsuario
    (import DataBase ?ALL)
    (import Templates ?ALL)
    (import TipoPregunta ?ALL)
    (export ?ALL)
)

;===================================================================================================;
;============================================== DATOS ==============================================;
;===================================================================================================;

; Pregunta al usuario por su nombre
(defrule preguntar-nombre
    ?state <- (estado (pregunta-1 1))
    ?grupo <- (datos-grupo)
	=>
    (printout t "Introduzca su nombre: " crlf)
    (bind ?nombre (read))

    ; Guardamos el nombre en el template
    (modify ?grupo (nombre ?nombre))
    (retract ?state)

    ; Activamos la siguiente pregunta
    (assert (estado (pregunta-2 1)))
    (printout t crlf)
)

; Pregunta al usuario por el tipo de visitante
(defrule preguntar-tipo
    ?state <- (estado (pregunta-2 1))
	?grupo <- (datos-grupo)
    =>
    (printout t "Selecciona el tamaño del grupo de visitantes:" crlf)
    (printout t "1. Una persona" crlf)
    (printout t "2. Una familia" crlf)
    (printout t "3. Un grupo pequeño (2-5 personas)" crlf)
    (printout t "4. Un grupo grande (>5 personas)" crlf)
    (bind ?opcion (pregunta-numerica "Ingresa un número del 1 al 4" 1 4))

    ; Obtenemos el tipo de visitante
    (bind $?opciones (create$ "Persona" "Familia" "GrupoPequeno" "GrupoGrande"))
    (bind ?tipo (nth$ ?opcion ?opciones))

    ; Guardamos el tipo de visitante en el template
    (modify ?grupo (tipo ?tipo))
    (retract ?state)

    ; Activamos la siguiente pregunta
    (assert (estado (pregunta-3 1)))
    (printout t crlf)
)

; Pregunta al usuario por el numero de dias que durara su visita
(defrule preguntar-dias
    ?state <- (estado (pregunta-3 1))
    ?grupo <- (datos-grupo)
    =>
    (printout t "¿Cuántos días durará su visita al Museo?" crlf)
    (bind ?dias (pregunta-numerica "Ingresa un número del 1 al 7" 1 7))

    ; Guardamos el numero de dias en el template
    (modify ?grupo (dias ?dias))
    (retract ?state)

    ; Activamos la siguiente pregunta
    (assert (estado (pregunta-4 1)))
    (printout t crlf)
)

; Pregunta al usuario por el numero de horas que desea visitar el museo por dia
(defrule preguntar-horas
    ?state <- (estado (pregunta-4 1))
    ?grupo <- (datos-grupo)
    =>
    (printout t "¿Cuántas horas, como máximo, deseas visitar el museo por día?" crlf)
    (bind ?horas (pregunta-numerica "Ingresa un número del 1 al 8" 1 8)) 
    
    ; Guardamos el numero de horas en el template
    (modify ?grupo (horas ?horas))
    (retract ?state)

    ; Activamos la siguiente pregunta
    (assert (estado (pregunta-5 1)))
    (printout t crlf)
)

; Determina el conocimiento del usuario en base a preguntas artisticas
(defrule preguntar-conocimiento
    ?state <- (estado (pregunta-5 1))
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
    (bind ?respuesta1 (pregunta-numerica "Ingresa un número del 1 al 4" 1 4))
    (if (eq ?respuesta1 1) then (bind ?puntos (+ ?puntos 1)))
    (printout t crlf)

    ; Segunda pregunta
    (printout t "B) ¿En qué periodo tuvo lugar el Renacimiento?" crlf)
    (printout t "   1. Siglo XIII" crlf)
    (printout t "   2. Siglo XIV al XVI" crlf)
    (printout t "   3. Siglo XVII" crlf)
    (printout t "   4. Siglo XVIII" crlf)
    (bind ?respuesta2 (pregunta-numerica "Ingresa un número del 1 al 4" 1 4))
    (if (eq ?respuesta2 2) then (bind ?puntos (+ ?puntos 1)))
    (printout t crlf)

    ; Tercera pregunta
    (printout t "C) ¿Qué características definen al arte barroco?" crlf)
    (printout t "   1. Simetría y simplicidad" crlf)
    (printout t "   2. Uso dramático de la luz y el movimiento" crlf)
    (printout t "   3. Representaciones abstractas" crlf)
    (printout t "   4. Colores pastel y escenas idílicas" crlf)
    (bind ?respuesta3 (pregunta-numerica "Ingresa un número del 1 al 4" 1 4))
    (if (eq ?respuesta3 2) then (bind ?puntos (+ ?puntos 1)))
    (printout t crlf)

    ; Cuarta pregunta
    (printout t "D) ¿Qué obra pintó Vincent van Gogh?" crlf)
    (printout t "   1. Las Meninas" crlf)
    (printout t "   2. La noche estrellada" crlf)
    (printout t "   3. El grito" crlf)
    (printout t "   4. La Gioconda" crlf)
    (bind ?respuesta4 (pregunta-numerica "Ingresa un número del 1 al 4" 1 4))
    (if (eq ?respuesta4 2) then (bind ?puntos (+ ?puntos 1)))
    (printout t crlf)

    ; Quinta pregunta
    (printout t "E) ¿Qué pintor es famoso por sus retratos de la corte española del siglo XVII?" crlf)
    (printout t "   1. Diego Velázquez" crlf)
    (printout t "   2. Sandro Botticelli" crlf)
    (printout t "   3. Rafael Sanzio" crlf)
    (printout t "   4. Pieter Bruegel el Viejo" crlf)
    (bind ?respuesta5 (pregunta-numerica "Ingresa un número del 1 al 4" 1 4))
    (if (eq ?respuesta5 1) then (bind ?puntos (+ ?puntos 1)))
    (printout t crlf)
    (printout t "Gracias por responder!" crlf)

    ; Guardamos el conocimiento en el template
    (modify ?grupo (conocimiento ?puntos))
    (retract ?state)

    ; Activamos la siguiente pregunta
    (assert (estado (pregunta-6 1)))
    (printout t crlf)
)

;===================================================================================================;
;=========================================== PREFERENCIAS ==========================================;
;===================================================================================================;

; Pregunta al usuario por sus pintores favoritos
(defrule preguntar-pintor-favorito
    ?state <- (estado (pregunta-6 1))
    ?preferencias <- (preferencias-grupo)
    =>
    (printout t "Selecciona tus pintores favoritos de la lista." crlf)

    ; Obtenemos las instancias de los pintores
    (bind ?instancias (find-all-instances ((?inst Pintor)) TRUE))

    ; Obtenemos los nombres de los pintores
    (bind ?pintores (create$))
    (foreach ?pintor ?instancias
        (bind ?pintores (create$ ?pintores (send ?pintor get-Nombre)))
    )

    ; Indexamos los pintores
    (bind ?count 0)
    (foreach ?autor ?pintores
        (bind ?count (+ ?count 1))
        (printout t "   " ?count ". " ?autor crlf)
    )
    
    (bind ?selecciones (pregunta-multiseleccion "Introduce los números de tus pintores preferidos, separados por espacios"))

    ; Obtenemos los pintores seleccionados
    (bind ?pintores-fav (create$))
    (foreach ?idx ?selecciones
        (bind ?pintores-fav (create$ ?pintores-fav (nth$ ?idx ?pintores)))
    )

    ; Guardamos los pintores favoritos en el template
    (modify ?preferencias (pintores ?pintores-fav))
    (retract ?state)

    ; Activamos la siguiente pregunta
    (assert (estado (pregunta-7 1)))
    (printout t crlf)
)

; Pregunta al usuario por sus tematicas favoritas
(defrule pregunta-tematica-favorita
    ?state <- (estado (pregunta-7 1))
    ?preferencias <- (preferencias-grupo)
    =>
    (printout t "Selecciona tus temáticas favoritas de la lista." crlf)
    
    ; Obtenemos las instancias de los cuadros
    (bind ?instancias (find-all-instances ((?inst Cuadro)) TRUE))

    ; Obtenemos las tematicas de los cuadros
    (bind ?tematicas (create$))
    (foreach ?obra ?instancias
        (bind ?tematicas (create$ ?tematicas (send ?obra get-Tematica)))
    )
    (bind ?tematicas-unicas (eliminar-repetidos$ ?tematicas))

    ; Indexamos las tematicas
    (bind ?count 0)
    (foreach ?tematica ?tematicas-unicas
        (bind ?count (+ ?count 1))
        (printout t "   " ?count ". " ?tematica crlf)
    )

    (bind ?selecciones (pregunta-multiseleccion "Introduce los números de tus temáticas preferidas, separados por espacios"))

    ; Obtenemos las tematicas seleccionadas
    (bind ?tematicas-fav (create$))
    (foreach ?idx ?selecciones
        (bind ?tematicas-fav (create$ ?tematicas-fav (nth$ ?idx ?tematicas-unicas)))
    )

    ; Guardamos las tematicas favoritas en el template
    (modify ?preferencias (tematicas ?tematicas-fav))
    (retract ?state)

    ; Activamos la siguiente pregunta
    (assert (estado (pregunta-8 1)))
    (printout t crlf)
)

; Pregunta al usuario por sus estilos favoritos
(defrule pregunta-estilo-favorito
    ?state <- (estado (pregunta-8 1))
    ?preferencias <- (preferencias-grupo)
    =>
    (printout t "Selecciona tus estilos favoritos de la lista" crlf)

    ; Obtenemos las instancias de los cuadros
    (bind ?instancias (find-all-instances ((?inst Cuadro)) TRUE))

    ; Obtenemos los estilos de los cuadros
    (bind ?estilos (create$))
    (foreach ?obra ?instancias
        (bind ?estilos (create$ ?estilos (send ?obra get-Estilo)))
    )
    (bind ?estilos-unicos (eliminar-repetidos$ ?estilos))
    
    ; Indexamos los estilos
    (bind ?count 0)
    (foreach ?estilo ?estilos-unicos
        (bind ?count (+ ?count 1))
        (printout t "   " ?count ". " ?estilo crlf)
    )

    (bind ?selecciones (pregunta-multiseleccion "Introduce los números de tus estilos preferidos, separados por espacios"))

    ; Obtenemos los estilos seleccionados
    (bind ?estilos-fav (create$))
    (foreach ?idx ?selecciones
        (bind ?estilos-fav (create$ ?estilos-fav (nth$ ?idx ?estilos-unicos)))
    )

    ; Guardamos los estilos favoritos en el template
    (modify ?preferencias (estilos ?estilos-fav))
    (retract ?state)

    ; Activamos la siguiente pregunta
    (assert (estado (pregunta-9 1)))
    (printout t crlf)
)

; Pregunta al usuario por sus epocas favoritas
(defrule pregunta-epoca-favorita
    ?state <- (estado (pregunta-9 1))
    ?preferencias <- (preferencias-grupo)
    =>
    (printout t "Selecciona tus épocas favoritas de la lista." crlf)

    ; Obtenemos las instancias de los cuadros
    (bind ?instancias (find-all-instances ((?inst Cuadro)) TRUE))

    ; Obtenemos las epocas de los cuadros
    (bind ?epocas (create$))
    (foreach ?obra ?instancias
        (bind ?epocas (create$ ?epocas (send ?obra get-Epoca)))
    )
    (bind ?epocas-unicas (eliminar-repetidos$ ?epocas))
    
    ; Indexamos las epocas
    (bind ?count 0)
    (foreach ?epoca ?epocas-unicas
        (bind ?count (+ ?count 1))
        (printout t "   " ?count ". " ?epoca crlf)
    )

    (bind ?selecciones (pregunta-multiseleccion "Introduce los números de tus épocas preferidas, separados por espacios"))

    ; Obtenemos las epocas seleccionadas
    (bind ?epocas-fav (create$))
    (foreach ?idx ?selecciones
        (bind ?epocas-fav (create$ ?epocas-fav (nth$ ?idx ?epocas-unicas)))
    )

    ; Guardamos las epocas favoritas en el template
    (modify ?preferencias (epocas ?epocas-fav))
    (retract ?state)
    (printout t crlf)
)