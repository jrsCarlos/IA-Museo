(defmodule tipoPregunta (export ?ALL))


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
    (bind ?entrada (readline))              ; Lee la entrada como cadena
    (bind ?palabras (explode$ ?entrada))    ; Divide la entrada en una lista de cadenas
    (printout t ?palabras crlf)
    (bind ?selecciones (create$))           ; Crea un multifield vacío

    (foreach ?idx ?palabras
        ;(bind ?num ?w)               ; Convertimos la cadena a int
        (bind ?selecciones 
            (insert$ ?selecciones (+ (length$ ?selecciones) 1) ?idx)  ; Agregamos el numero a la lista de selecciones
        )
    )

    ?selecciones
)

(deffunction remove-all-instances$ (?el ?lst)
   (if (eq (length$ ?lst) 0) then
      (return ?lst)
   )
   (bind ?head (nth$ 1 ?lst))
   (bind ?tail (subseq$ ?lst 2 (length$ ?lst)))
   (if (eq ?head ?el) then
       ; Si el elemento actual es el que queremos eliminar,
       ; no lo incluimos y seguimos procesando el tail
       (return (remove-all-instances$ ?el ?tail))
    else
       ; Si no es el elemento a eliminar, lo mantenemos y seguimos
       (return (create$ ?head (remove-all-instances$ ?el ?tail)))
   )
)

(deffunction remove-duplicates$ (?list)
   (if (eq (length$ ?list) 0) then
       (return ?list)
   )
   (bind ?head (nth$ 1 ?list))
   (bind ?tail (subseq$ ?list 2 (length$ ?list)))
   ; Removemos todas las ocurrencias de ?head en el resto
   (bind ?filtered-tail (remove-all-instances$ ?head ?tail))
   ; Removemos duplicados del resto filtrado
   (bind ?rest (remove-duplicates$ ?filtered-tail))
   ; Devolvemos una nueva lista con el head y el resto depurado
   (return (create$ ?head ?rest))
)