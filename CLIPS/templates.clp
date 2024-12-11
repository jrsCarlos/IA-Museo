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
    ; Pese a que las preguntas son de tipo INTEGER, cumplen la funcion de booleanos
    (slot pregunta-1 (type INTEGER) (default 0))
    (slot pregunta-2 (type INTEGER) (default 0))
    (slot pregunta-3 (type INTEGER) (default 0))
    (slot pregunta-4 (type INTEGER) (default 0))
    (slot pregunta-5 (type INTEGER) (default 0))
    (slot pregunta-6 (type INTEGER) (default 0))
    (slot pregunta-7 (type INTEGER) (default 0))
    (slot pregunta-8 (type INTEGER) (default 0))
    (slot pregunta-9 (type INTEGER) (default 0))
)
