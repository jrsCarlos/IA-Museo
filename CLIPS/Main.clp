(defmodule MAIN
    (import DataBase ?ALL)
    (import Templates ?ALL)
    (import TipoPregunta ?ALL)
    (import PreguntasUsuario ?ALL)
    (export ?ALL)
)

(defrule MAIN::inicio
	(declare (salience 10))
	=>
  	(printout t crlf)  	
    (printout t "-------------------------------------------------------------------------------" crlf)
    (printout t "                                  ¡Bienvenid@!                                 " crlf)
	(printout t "A continuación se le formularán una serie de preguntas sus datos y preferencias" crlf)
    (printout t "     artísticas para poder organizarle una visita guiada por nuestro museo     " crlf)
    (printout t "-------------------------------------------------------------------------------" crlf)
    (printout t crlf)

    ; Ceamos las variables donde almacenaremos la informacion del usuario
    (assert (datos-grupo))
    (assert (preferencias-grupo))

    ; Iniciamos el flujo de preguntas
    (assert (estado (pregunta-1 1)))
    (focus PreguntasUsuario)
)

(deffunction MAIN::imprimir-recomendacion
    ()
    (printout t "Recomendacion" crlf)
    
    (foreach ?pref (find-all-facts ((?f preferencias-grupo)) TRUE)
        (bind ?epocas (fact-slot-value ?pref epocas) crlf)
        (foreach ?epoca ?epocas
            (if (stringp ?epoca) then (printout t "Epoca: " ?epoca crlf))
            (bind ?obras (find-all-instances ((?inst Cuadro)) (eq ?inst:Epoca ?epoca)))
            (foreach ?o ?obras
                (printout t "   " (send ?o get-Titulo) crlf)
            )
        )
    )
)

; Imprimimos la información recolectada del usuario
(defrule MAIN::imprimir-datos-recolectados
    =>
    (printout t "----------------------------------------------------------" crlf)
    (printout t "             Resumen de los datos recolectados            " crlf)
    (printout t "----------------------------------------------------------" crlf)

    ;; Datos del grupo
    (foreach ?dato (find-all-facts ((?f datos-grupo)) TRUE)
        (printout t "Nombre: "                 (fact-slot-value ?dato nombre) crlf)
        (printout t "Tipo de visitante: "      (fact-slot-value ?dato tipo) crlf)
        (printout t "Conocimiento artístico: " (fact-slot-value ?dato conocimiento) "/5" crlf)
        (printout t "Días de Visita: "         (fact-slot-value ?dato dias) crlf)
        (printout t "Horas máximas por día: "  (fact-slot-value ?dato horas) crlf)
    )

    ;; Preferencias del grupo
    (foreach ?pref (find-all-facts ((?f preferencias-grupo)) TRUE)
        (printout t "Autores favoritos: "   (fact-slot-value ?pref pintores) crlf)
        (printout t "Temáticas favoritas: " (fact-slot-value ?pref tematicas) crlf)
        (printout t "Estilos favoritos: "   (fact-slot-value ?pref estilos) crlf)
        (printout t "Épocas favoritas: "    (fact-slot-value ?pref epocas) crlf)
    )

    (printout t "----------------------------------------------------------" crlf)
    (imprimir-recomendacion)
)
