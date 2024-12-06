(defmodule templates (export ?ALL))

;================================================================================================;
;=========================================== TEMPLATES ==========================================;
;================================================================================================;

(deftemplate datos_grupo
	(slot nombre (type STRING) (default "Desconocido")) 
    (slot tipo (type STRING) (default "Indefinido")) 
	(slot conocimiento (type INTEGER) (default -1)) 
    (slot dias (type INTEGER) (default -1)) 
    (slot horas (type INTEGER) (default -1))
)

(deftemplate preferencias_grupo
	(multislot pintores_favoritos (type INSTANCE) (default (create$)))
	(multislot tematicas_favoritas (type INSTANCE) (default (create$)))
	(multislot estilos_favoritos (type INSTANCE) (default (create$)))
	(multislot epocas_favoritas (type INSTANCE) (default (create$)))
)

(deftemplate estado
    (slot primera_pregunta (type SYMBOL) (allowed-values TRUE FALSE) (default FALSE)) 
    (slot segunda_pregunta (type SYMBOL) (allowed-values TRUE FALSE) (default FALSE)) 
    (slot tercera_pregunta (type SYMBOL) (allowed-values TRUE FALSE) (default FALSE)) 
    (slot cuarta_pregunta (type SYMBOL) (allowed-values TRUE FALSE) (default FALSE)) 
    (slot quinta_pregunta (type SYMBOL) (allowed-values TRUE FALSE) (default FALSE)) 
    (slot sexta_pregunta (type SYMBOL) (allowed-values TRUE FALSE) (default FALSE)) 
    (slot septima_pregunta (type SYMBOL) (allowed-values TRUE FALSE) (default FALSE)) 
    (slot octava_pregunta (type SYMBOL) (allowed-values TRUE FALSE) (default FALSE)) 
    (slot novena_pregunta (type SYMBOL) (allowed-values TRUE FALSE) (default FALSE)) 
)