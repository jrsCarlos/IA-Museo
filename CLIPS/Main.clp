(defmodule MAIN
    (import DataBase ?ALL)
    (import Templates ?ALL)
    (import TipoPregunta ?ALL)
    (import PreguntasUsuario ?ALL)
    (export ?ALL)
)

(defrule MAIN::ini "Iniciamos el programa"
	(declare (salience 10))
	=>
  	(printout t crlf)  	
    (printout t "-----------------------------------------------------------------------------------------------------------------------------------" crlf)
	(printout t "¡Bienvenido! A continuacion se le formularan una serie de preguntas para poder recomendarle una visita adecuada a sus preferencias." crlf)
	(printout t "-----------------------------------------------------------------------------------------------------------------------------------" crlf)
    (printout t crlf)

    (assert (datos-grupo))
    (assert (estado (primera_pregunta TRUE)))

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
