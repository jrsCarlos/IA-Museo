 ; Cargamos todas las instancias

(defmodule main (export ?ALL) (import preguntas-preferencias ?all) (import preguntas-visitantes ?all) (import templates))

;================================================================================================;
;============================================ MODULOS ===========================================;
;================================================================================================;


;================================================================================================;
;=========================================== MENSAJES ===========================================;
;================================================================================================;


;================================================================================================;
;=========================================== FUNCIONES ==========================================;
;================================================================================================;


;================================================================================================;
;============================================ REGLAS ============================================;
;================================================================================================;

(defrule inicializacion "Iniciamos el programa"
	(declare (salience 10))
	=>
  	(printout t crlf)  	
    (printout t"----------------------------------------------------------" crlf)
	(printout t"¡Bienvenido! A continuacion se le formularan una serie de preguntas para poder recomendarle una visita adecuada a sus preferencias." crlf)
	(printout t"----------------------------------------------------------" crlf)
    (printout t crlf)

    (assert (FasePreguntasVitantes1))
    ;(focus preguntas-preferencias)
)


(defrule imprimir-datos-recolectados
    "Imprime todos los datos recolectados del usuario"
    =>
    (printout t crlf "----------------------------------------------------------" crlf)
    (printout t "Resumen de datos recolectados:" crlf)
    (printout t "----------------------------------------------------------" crlf)

    ;; Datos del grupo
    (foreach ?dato (find-all-facts ((?f datos_grupo)) TRUE)
        (printout t "Nombre: " (fact-slot-value ?dato nombre) crlf)
        (printout t "Tipo de Visitantes: " (fact-slot-value ?dato tipoDeVisitantes) crlf)
        (printout t "Conocimiento en Arte: " (fact-slot-value ?dato conocimiento) "/5" crlf)
        (printout t "Días de Visita: " (fact-slot-value ?dato dias) crlf)
        (printout t "Horas máximas por día: " (fact-slot-value ?dato horas) crlf)
    )

    ;; Preferencias del grupo
    (foreach ?pref (find-all-facts ((?f preferencias_grupo)) TRUE)
        (printout t "Autores favoritos: " (fact-slot-value ?pref autores_favoritos) crlf)
        (printout t "Temáticas favoritas: " (fact-slot-value ?pref tematicas_obras_fav) crlf)
        (printout t "Estilos favoritos: " (fact-slot-value ?pref estilos_favoritos) crlf)
        (printout t "Épocas favoritas: " (fact-slot-value ?pref epocas_favoritas) crlf)
    )

    ;; Fin del resumen
    (printout t "----------------------------------------------------------" crlf)
    (printout t "Fin de los datos recolectados." crlf crlf)
)