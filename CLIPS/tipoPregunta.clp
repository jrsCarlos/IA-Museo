(defmodule TipoPregunta (export ?ALL))

;===================================================================================================;
;============================================ PREGUNTAS ============================================;
;===================================================================================================;

; Hace una pregunta cuya respuesta puede contener mas de una opcion
(deffunction pregunta-multiseleccion (?pregunta)
    ; Hacemos la pregunta
    (printout t ?pregunta crlf)
    (bind ?entrada (readline))

    ; Separamos las palabras
    (bind ?palabras (explode$ ?entrada))

    ; Creamos una lista vacia para guardar las selecciones
    (bind ?selecciones (create$))
    (foreach ?idx ?palabras
        ; Añadimos la seleccion a la lista
        (bind ?selecciones (insert$ ?selecciones (+ (length$ ?selecciones) 1) ?idx))
    )
    ?selecciones
)

; Hace una pregunta cuya respuesta es un numero dentro de un rango
(deffunction pregunta-numerica (?pregunta ?rangini ?rangfi)
    ; Hacemos la pregunta
    (printout t ?pregunta crlf)
	(bind ?respuesta (read))

    ; Mientras la respuesta no este en el rango permitido, volvemos a preguntar
	(while (not (and (>= ?respuesta ?rangini) (<= ?respuesta ?rangfi))) do 
        (printout t ?pregunta crlf)
        (bind ?respuesta (read))
	)
	?respuesta
)

;===================================================================================================;
;======================================== FUNCIONES AUXILIARES =====================================;
;===================================================================================================;

; Elimina los elementos repetidos de una lista
(deffunction eliminar-repetidos$ ($?lista)
    ; Inicializamos una lista vacía
    (bind ?resultado (create$))
    (foreach ?elemento ?lista
        ; Si el elemento no esta en la lista resultado, lo afegim
        (if (not (member$ ?elemento ?resultado)) then
            (bind ?resultado (create$ ?resultado ?elemento))
        )
    )
    ?resultado
)
