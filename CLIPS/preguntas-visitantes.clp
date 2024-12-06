(defmodule preguntas-visitantes (import templates ?ALL) (import tipoPregunta ?ALL) (export ?ALL))

(defrule pregunta_nombre "Preguntar el nombre al usuario"
    ?state <- (estado (primera_pregunta ?t)) 
    (test (eq ?t TRUE))
    ?grupo <- (datos_grupo)
	=>
    (printout t "Por favor, introduzca su nombre: " crlf)
    (bind ?nombre (read))
    (printout t "¡Gracias, " ?nombre "! Continuemos con las preguntas." crlf)
    (modify ?grupo (nombre ?nombre))
    (retract ?state)
    (assert (estado (segunda_pregunta TRUE)))
)

(defrule pregunta_tipo "Preguntar el tamaño del grupo"
    ?state <- (estado (segunda_pregunta ?t))
    (test (eq ?t TRUE))
	?grupo <- (datos_grupo)
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
)

(defrule pregunta_conocimiento "Establecer el conocimiento del visitante"
    ?state <- (estado (tercera_pregunta ?t))
    (test (eq ?t TRUE))
    ?grupo <- (datos_grupo)
    =>
    (printout t "Evaluaremos su conocimiento en arte. Responda las siguientes preguntas:" crlf)
    (bind ?puntos 0) ; Inicializamos los puntos acumulados

    ; Aqui tmb, se pueden utilizar las funciones ya creadas?
    ; Primera pregunta
    (printout t "1. ¿Quién pintó 'La Última Cena'?" crlf)
    (printout t "   1. Leonardo da Vinci" crlf)
    (printout t "   2. Pablo Picasso" crlf)
    (printout t "   3. Vincent van Gogh" crlf)
    (printout t "   4. Claude Monet" crlf)
    (bind ?respuesta1 (pregunta-numerica "Elija una opción" 1 4))
    (if (eq ?respuesta1 1) then (bind ?puntos (+ ?puntos 1)))

    ; Segunda pregunta
    (printout t "2. ¿En qué periodo tuvo lugar el Renacimiento?" crlf)
    (printout t "   1. Siglo XIII" crlf)
    (printout t "   2. Siglo XIV al XVI" crlf)
    (printout t "   3. Siglo XVII" crlf)
    (printout t "   4. Siglo XVIII" crlf)
    (bind ?respuesta2 (pregunta-numerica "Elija una opción" 1 4))
    (if (eq ?respuesta2 2) then (bind ?puntos (+ ?puntos 1)))

    ; Tercera pregunta
    (printout t "3. ¿Qué característica define el arte barroco?" crlf)
    (printout t "   1. Simetría y simplicidad" crlf)
    (printout t "   2. Uso dramático de la luz y el movimiento" crlf)
    (printout t "   3. Representaciones abstractas" crlf)
    (printout t "   4. Colores pastel y escenas idílicas" crlf)
    (bind ?respuesta3 (pregunta-numerica "Elija una opción" 1 4))
    (if (eq ?respuesta3 2) then (bind ?puntos (+ ?puntos 1)))

    ; Cuarta pregunta
    (printout t "4. ¿Qué obra pintó Vincent van Gogh?" crlf)
    (printout t "   1. Las Meninas" crlf)
    (printout t "   2. La noche estrellada" crlf)
    (printout t "   3. El grito" crlf)
    (printout t "   4. La Gioconda" crlf)
    (bind ?respuesta4 (pregunta-numerica "Elija una opción" 1 4))
    (if (eq ?respuesta4 2) then (bind ?puntos (+ ?puntos 1)))

    ; Quinta pregunta
    (printout t "5. ¿Qué pintor es famoso por sus retratos de la corte española del siglo XVII?" crlf)
    (printout t "   1. Diego Velázquez" crlf)
    (printout t "   2. Sandro Botticelli" crlf)
    (printout t "   3. Rafael Sanzio" crlf)
    (printout t "   4. Pieter Bruegel el Viejo" crlf)
    (bind ?respuesta5 (pregunta-numerica "Elija una opción" 1 4))
    (if (eq ?respuesta5 1) then (bind ?puntos (+ ?puntos 1)))
    (printout t "Gracias por responder. Su nivel de conocimiento en arte es: " ?puntos "/5." crlf)


    ; Asignar el conocimiento acumulado al slot
    (modify ?grupo (conocimiento ?puntos))
    (retract ?state)
    (assert (estado (cuarta_pregunta TRUE)))
)

(defrule pregunta_diasDeVisita "Preguntar el número de días de visita"
    ?state <- (estado (cuarta_pregunta ?t))
    (test (eq ?t TRUE))
    ?grupo <- (datos_grupo)
    =>
    (printout t "¿Cuántos días desea visitar el museo? (Introduzca un número positivo)" crlf)
    (bind ?dias (pregunta-numerica "Ingrese el número de días" 1 100)) 
    (modify ?grupo (dias ?dias))
    (retract ?state)
    (assert (estado (quinta_pregunta TRUE)))
)

(defrule pregunta_horasVisita "Preguntar la cota superior de horas de visita diaria"
    ?state <- (estado (quinta_pregunta ?t))
    (test (eq ?t TRUE))
    ?grupo <- (datos_grupo)
    =>
    (printout t "¿Cuántas horas como máximo desea visitar el museo por día? (Introduzca un número entre 1 y 12)" crlf)
    (bind ?horas (pregunta-numerica "Ingrese el número de horas por día" 1 12)) 
    
    (modify ?grupo (horas ?horas))
    (retract ?state)
)