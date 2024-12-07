(defmodule TipoPregunta (export ?ALL))

(deffunction pregunta-multiseleccion (?pregunta)
    (printout t ?pregunta crlf)
    (bind ?entrada (readline))
    (bind ?palabras (explode$ ?entrada))
    (printout t ?palabras crlf)
    (bind ?selecciones (create$))

    (foreach ?idx ?palabras
        (bind ?selecciones 
            (insert$ ?selecciones (+ (length$ ?selecciones) 1) ?idx)
        )
    )

    ?selecciones
)

(deffunction pregunta-numerica (?pregunta ?rangini ?rangfi)
	(format t "%s (De %d hasta %d) " ?pregunta ?rangini ?rangfi)
	(bind ?respuesta (read))
	(while (not (and (>= ?respuesta ?rangini) (<= ?respuesta ?rangfi))) do 
        (format t "%s (De %d hasta %d) " ?pregunta ?rangini ?rangfi)
        (bind ?respuesta (read))
	)
	?respuesta
)

(deffunction pregunta-opciones (?pregunta $?valores-posibles)
    (bind ?linea (format nil "%s" ?pregunta))
    (printout t ?linea crlf)
    (progn$ (?var ?valores-posibles)
            (bind ?linea (format nil "  %d. %s" ?var-index ?var))
            (printout t ?linea crlf)
    )
    (bind ?respuesta (pregunta-numerica "Escoge una opcion:" 1 (length$ ?valores-posibles)))
	?respuesta
)

(deffunction remove-all-instances$ (?el ?lst)
    (if (eq (length$ ?lst) 0) then (return ?lst))
    (bind ?head (nth$ 1 ?lst))
    (bind ?tail (subseq$ ?lst 2 (length$ ?lst)))
    (if (eq ?head ?el) then
        (return (remove-all-instances$ ?el ?tail))
    else
        (return (create$ ?head (remove-all-instances$ ?el ?tail)))
    )
)

(deffunction remove-duplicates$ (?list)
    (if (eq (length$ ?list) 0) then
        (return ?list)
    )
    (bind ?head (nth$ 1 ?list))
    (bind ?tail (subseq$ ?list 2 (length$ ?list)))
    (bind ?filtered-tail (remove-all-instances$ ?head ?tail))
    (bind ?rest (remove-duplicates$ ?filtered-tail))
    (return (create$ ?head ?rest))
)