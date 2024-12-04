
(defmodule templates (export ?ALL))
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