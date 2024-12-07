(defmodule Templates (export ?ALL))

;===================================================================================================;
;==========================================   TEMPLATES   ==========================================;
;===================================================================================================;

; Templates para almecenar la informacion introducida por el usurio
(deftemplate datos-grupo
	(slot nombre       (type STRING)  (default "Desconocido"))
    (slot tipo         (type STRING)  (default "Indefinido"))
	(slot conocimiento (type INTEGER) (default -1))
    (slot dias         (type INTEGER) (default -1))
    (slot horas        (type INTEGER) (default -1))
)

(deftemplate preferencias-grupo
	(multislot pintores  (type INSTANCE) (default (create$)))
	(multislot tematicas (type INSTANCE) (default (create$)))
	(multislot estilos   (type INSTANCE) (default (create$)))
	(multislot epocas    (type INSTANCE) (default (create$)))
)

; Template para almacenar el estado de las preguntas que controlan el flujo del programa
(deftemplate estado
    (slot primera_pregunta (type SYMBOL) (allowed-values TRUE FALSE) (default FALSE)) 
    (slot segunda_pregunta (type SYMBOL) (allowed-values TRUE FALSE) (default FALSE)) 
    (slot tercera_pregunta (type SYMBOL) (allowed-values TRUE FALSE) (default FALSE)) 
    (slot cuarta_pregunta  (type SYMBOL) (allowed-values TRUE FALSE) (default FALSE)) 
    (slot quinta_pregunta  (type SYMBOL) (allowed-values TRUE FALSE) (default FALSE)) 
    (slot sexta_pregunta   (type SYMBOL) (allowed-values TRUE FALSE) (default FALSE)) 
    (slot septima_pregunta (type SYMBOL) (allowed-values TRUE FALSE) (default FALSE)) 
    (slot octava_pregunta  (type SYMBOL) (allowed-values TRUE FALSE) (default FALSE)) 
    (slot novena_pregunta  (type SYMBOL) (allowed-values TRUE FALSE) (default FALSE)) 
)