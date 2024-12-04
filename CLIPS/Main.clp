(load "DataBase.clp")
(load "tipoPreguntas.clp")
(load "preguntaVisitantes.clp")
(load "preguntaPreferencias.clp")  ; Cargamos todas las instancias

(defmodule main (export ?ALL))

;================================================================================================;
;=========================================== TEMPLATES ==========================================;
;================================================================================================;

(deftemplate datos_grupo
	(slot nombre (type STRING) (default "Desconocido")) 
    (slot tipoDeVisitantes (type STRING) (default "Indefinido")) 
	(slot conocimiento (type INTEGER) (default -1)) 
    (slot dias (type INTEGER) (default -1)) 
    (slot horas (type INTEGER) (default -1)) ; la cota superior de horas de visita en un día.
)

(deftemplate preferencias_grupo
	(multislot autores_favoritos (type INSTANCE))
	(multislot tematicas_obras_fav (type INSTANCE)) ; mostrar la opción de religión
	(multislot estilos_favoritos (type INSTANCE))
	(multislot epocas_favoritas (type INSTANCE))
)

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
	(focus preguntas-visitantes)
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