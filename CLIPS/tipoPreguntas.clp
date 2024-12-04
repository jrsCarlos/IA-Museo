(defmodule tipo-preguntas
    (import main ?ALL)
    (export ?ALL)
)

(deffunction pregunta-numerica 
    (?pregunta ?rangini ?rangfi)
	(format t "%s (De %d hasta %d) " ?pregunta ?rangini ?rangfi)
	(bind ?respuesta (read))
	(while (not (and (>= ?respuesta ?rangini) (<= ?respuesta ?rangfi))) do 
        (format t "%s (De %d hasta %d) " ?pregunta ?rangini ?rangfi) ; se podria añadir un salta de linea con ~% despues de (De %d hasta %d), pero vamos viendo
        (bind ?respuesta (read))
	)
	?respuesta
)

(deffunction pregunta-opciones 
    (?pregunta $?valores-posibles)
    (bind ?linea (format nil "%s" ?pregunta))
    (printout t ?linea crlf)
    (progn$ (?var ?valores-posibles) ; Iteramos sobre los valores posibles
            (bind ?linea (format nil "  %d. %s" ?var-index ?var))
            (printout t ?linea crlf)
    )
    (bind ?respuesta (pregunta-numerica "Escoge una opcion:" 1 (length$ ?valores-posibles)))
	?respuesta
)

(deffunction pregunta-multiseleccion 
    (?pregunta)
    (printout t ?pregunta crlf)
    (bind ?entrada (readline))                  ; Lee la entrada del usuario como texto
    (bind ?selecciones (explode$ ?entrada))  ; Divide la entrada en una lista usando espacios
    (foreach ?i ?selecciones
        (bind ?selecciones (replace$ ?i (string-to-field ?i)))) ; Convierte las cadenas en números
    ?selecciones
)

(deffunction remove-duplicates$ 
    (?list)
    (if (neq (length$ ?list) 0) then
        (bind ?first-element (nth$ 1 ?list))
        (bind ?rest (remove-duplicates$ (remove ?first-element ?list)))
        (create$ ?first-element ?rest)
        else (return NULL)
    )
)

;(deffunction remove-duplicates$ 
;    (?list)
;    (if (neq (length$ ?list) 0) then
;        (bind ?first-element (nth$ 1 ?list))
;        (bind ?rest (remove-duplicates$ (remove ?first-element ?list)))
;        (return (create$ ?first-element (expand$ ?rest))) ; Usa expand$ para aplanar la lista
;        else
;        (return (create$))) ; Retorna una lista vacía en el caso base
;)