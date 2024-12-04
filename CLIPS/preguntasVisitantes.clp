(defmodule preguntas-visitantes
	(import main ?ALL)
    (import tipo-preguntas ?ALL)
	(export ?ALL)
)

(defrule pregunta_nombre "Preguntar el nombre al usuario"
    (declare (salience 5))
	=>
    (printout t "Por favor, introduzca su nombre: " crlf)
    (bind ?nombre (read))
    (assert (datos_grupo (nombre ?nombre)))
    (printout t "¡Gracias, " ?nombre "! Continuemos con las preguntas." crlf)
)

; Aqui no se podria utilizar pregunta-opciones??
(defrule pregunta_tipo "Preguntar el tamaño del grupo"
	?grupo <- (datos_grupo (tipoDeVisitantes ?))
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
    (assert (datos_grupo (tipoDeVisitantes ?tipo)))
)

(defrule pregunta_conocimiento "Establecer el conocimiento del visitante"
    ?grupo <- (datos_grupo (conocimiento ?))
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

    ; Asignar el conocimiento acumulado al slot
    (assert (datos_grupo (conocimiento ?puntos)))

    (printout t "Gracias por responder. Su nivel de conocimiento en arte es: " ?puntos "/5." crlf)
); Xinxiang me han molao las preguntas

(defrule pregunta_diasDeVisita "Preguntar el número de días de visita"
    ?grupo <- (datos_grupo (dias ?))
    =>
    (printout t "¿Cuántos días desea visitar el museo? (Introduzca un número positivo)" crlf)
    (bind ?dias (pregunta-numerica "Ingrese el número de días" 1 100)) 
    (modify ?grupo (dias ?dias))
)

; Porque aqui haces modify y en las otras reglas haces assert?
(defrule pregunta_horasVisita "Preguntar la cota superior de horas de visita diaria"
    ?grupo <- (datos_grupo (horas ?))
    =>
    (printout t "¿Cuántas horas como máximo desea visitar el museo por día? (Introduzca un número entre 1 y 12)" crlf)
    (bind ?horas (pregunta-numerica "Ingrese el número de horas por día" 1 12)) 
    (modify ?grupo (horas ?horas))
)

;Haria falta cambiar el foco a preguntas-preferencias?

;(defrule MAIN::finalizar-preguntas-visitantes
;    "Finalizar preguntas de visitantes"
;    ?grupo <- (datos_grupo)
;    =>
;    (printout t "¡Gracias por responder las preguntas! Ahora procederemos a preguntarle sobre sus preferencias artísticas." crlf)
;    (focus preguntas-preferencias)
;)