(defmodule MAIN (import templates ?ALL) (import tipoPregunta ?ALL) (import preguntas-visitantes ?ALL) (import DataBase ?ALL) (import preguntas-preferencias ?ALL)  (export ?ALL))

;================================================================================================;
;============================================ REGLAS ============================================;
;================================================================================================;

(defrule MAIN::ini "Iniciamos el programa"
	(declare (salience 10))
	=>
  	(printout t crlf)  	
    (printout t "-----------------------------------------------------------------------------------------------------------------------------------" crlf)
	(printout t "¡Bienvenido! A continuacion se le formularan una serie de preguntas para poder recomendarle una visita adecuada a sus preferencias." crlf)
	(printout t "-----------------------------------------------------------------------------------------------------------------------------------" crlf)
    (printout t crlf)

    (assert (datos_grupo))
    (assert (estado (primera_pregunta TRUE)))

    (focus preguntas-visitantes)
)

(defrule MAIN::mid
    =>
    (printout t "SAPO1" crlf)
    (assert (estado (sexta_pregunta TRUE)))
    (focus preguntas-preferencias)
)

(deffunction MAIN::imprimir-recomendacion
    ()
    (printout t "-----------------------------------------------------------------------------------------------------------------------------------" crlf)
    (printout t "-----------------------------------------------------------------------------------------------------------------------------------" crlf)
    (printout t "Recomendacion" crlf)
    
    (foreach ?pref (find-all-facts ((?f preferencias_grupo)) TRUE)
        (bind ?epocas (fact-slot-value ?pref epocas_favoritas) crlf)
        (foreach ?epoca ?epocas
            (if (stringp ?epoca) then (printout t "Epoca: " ?epoca crlf))
            ;(printout t "Epoca: " ?epoca crlf))
            (bind ?obras (find-all-instances ((?inst Cuadro)) (eq ?inst:Epoca ?epoca)))
            (foreach ?o ?obras
                (printout t "   " (send ?o get-Titulo) crlf)
            )
        )
    )
)

(defrule MAIN::imprimir-datos-recolectados
    "Imprime todos los datos recolectados del usuario"
    =>
    (printout t crlf "----------------------------------------------------------" crlf)
    (printout t "Resumen de datos recolectados:" crlf)
    (printout t "----------------------------------------------------------" crlf)

    ;; Datos del grupo
    (foreach ?dato (find-all-facts ((?f datos_grupo)) TRUE)
        (printout t "Nombre: " (fact-slot-value ?dato nombre) crlf)
        (printout t "Tipo de Visitantes: " (fact-slot-value ?dato tipo) crlf)
        (printout t "Conocimiento en Arte: " (fact-slot-value ?dato conocimiento) "/5" crlf)
        (printout t "Días de Visita: " (fact-slot-value ?dato dias) crlf)
        (printout t "Horas máximas por día: " (fact-slot-value ?dato horas) crlf)
    )

    ;; Preferencias del grupo
    (foreach ?pref (find-all-facts ((?f preferencias_grupo)) TRUE)
        (printout t "Autores favoritos: " (fact-slot-value ?pref pintores_favoritos) crlf)
        (printout t "Temáticas favoritas: " (fact-slot-value ?pref tematicas_favoritas) crlf)
        (printout t "Estilos favoritos: " (fact-slot-value ?pref estilos_favoritos) crlf)
        (printout t "Épocas favoritas: " (fact-slot-value ?pref epocas_favoritas) crlf)
    )

    ;; Fin del resumen
    (printout t "----------------------------------------------------------" crlf)
    (printout t "Fin de los datos recolectados." crlf crlf)
    (imprimir-recomendacion)
    ; (make-instance ?nombre of Visitante (ConocimientoArte ?conocimiento)
    ; (DiasDeVisita ?dias)(DuracionVisita ?horas)
    ; (TipoDeVisitante ?tipo) (nombre ?nombre)(preferencias ?preferencias))
)
