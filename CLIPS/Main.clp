(batch "DataBase.clp")  ; Cargamos todas las instancias

(defmodule MAIN (export ?ALL))

;================================================================================================;
;=========================================== TEMPLATES ==========================================;
;================================================================================================;

(deftemplate datos_grupo
	(slot nombre (type STRING) (default "Desconocido")) 
    (slot tipo (type STRING) (default "Indefinido")) 
	(slot conocimiento (type INTEGER) (default -1)) 
    (slot dias (type INTEGER) (default -1)) 
    (slot horas (type INTEGER) (default -1)) ; la cota superior de horas de visita en un día.
)

(deftemplate preferencias_grupo
	(multislot pintores_favoritos (type INSTANCE))
	(multislot tematicas_favoritas (type INSTANCE))
	(multislot estilos_favoritos (type INSTANCE))
	(multislot epocas_favoritas (type INSTANCE))
)

;================================================================================================;
;============================================ MODULOS ===========================================;
;================================================================================================;

(defmodule tipo-preguntas
    (import MAIN ?ALL)
    (export ?ALL)
)

(defmodule preguntas-visitantes
    (import MAIN ?ALL)
    (import tipo-preguntas ?ALL)
    (export ?ALL)
)

(defmodule preguntas-preferencias
    (import MAIN ?ALL)
    (import tipo-preguntas ?ALL)
    (import preguntas-visitantes deftemplate ?ALL)
    (export ?ALL)
)

;================================================================================================;
;=========================================== MENSAJES ===========================================;
;================================================================================================;


;================================================================================================;
;=========================================== FUNCIONES ==========================================;
;================================================================================================;

(set-current-module tipo-preguntas)
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
    (bind ?selecciones (create$))           ; Crea un multifield vacío

    (foreach ?w ?palabras
        (bind ?num (eval ?w))               ; Convertimos la cadena a int
        (bind ?selecciones 
            (insert$ ?selecciones (length$ ?selecciones) ?num)  ; Agregamos el numero a la lista de selecciones
        )
    )

    ?selecciones
)

; Esta función recibe un valor ?el y una lista ?lst
; y devuelve una lista idéntica a ?lst pero sin ?el.
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

; Ahora la función principal:
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

;================================================================================================;
;============================================ REGLAS ============================================;
;================================================================================================;

(defrule MAIN::ini "Iniciamos el programa"
	(declare (salience 10))
	=>
  	(printout t crlf)  	
    (printout t "-----------------------------------------------------------------------------------------------------------------------------------" crlf)
	(printout t "¡Bienvenido! A continuacion se le formularan una serie de preguntas para poder recomendarle una visita adecuada a sus preferencias." crlf)
	(printout t "-----------------------------------------------------------------------------------------------------------------------------------" crlf)
    (printout t crlf)

    (assert (datos_grupo))
    (assert (preferencias_grupo))
    (assert (estado flujo_inicial))

	(focus preguntas-visitantes)
    (focus preguntas-preferencias)
)

;Preguntar al profe si hace falta validación de entrada
(set-current-module preguntas-visitantes)
(defrule pregunta_nombre "Preguntar el nombre al usuario"
    ?state <- (estado flujo_inicial)
    ?grupo <- (datos_grupo)
	=>
    (printout t "Por favor, introduzca su nombre: " crlf)
    (bind ?nombre (read))
    (printout t "¡Gracias, " ?nombre "! Continuemos con las preguntas." crlf)
    (modify ?grupo (nombre ?nombre))
    (retract ?state)
    (assert (estado segunda_pregunta))
)

(defrule pregunta_tipo "Preguntar el tamaño del grupo"
    ?state <- (estado segunda_pregunta)
	?grupo <- (datos_grupo)
    =>
    (printout t "Selecciona el tamaño del grupo de visitantes:" crlf)
    (printout t "1. Una persona" crlf)
    (printout t "2. Una familia" crlf)
    (printout t "3. Un grupo pequeño (2-5 personas)" crlf)
    (printout t "4. Un grupo grande (>5 personas)" crlf)
    (bind ?opcion (pregunta-numerica "Elija una opción" 1 4))
    (bind ?tipo (nth$ ?opcion 
                (create$ "Persona" 
                         "Familia" 
                         "GrupoPequeno" 
                         "GrupoGrande"))
    )
    (modify ?grupo (tipo ?tipo))
    (retract ?state)
    (assert (estado tercera_pregunta))
)

(defrule pregunta_conocimiento "Establecer el conocimiento del visitante"
    ?state <- (estado tercera_pregunta)
    ?grupo <- (datos_grupo)
    =>
    (printout t "Evaluaremos su conocimiento en arte. Responda las siguientes preguntas:" crlf)
    (bind ?puntos 0) ; Inicializamos los puntos acumulados

    ; Aqui tmb, se pueden utilizar las funciones ya creadas?
    ; Primera pregunta
    (printout t "1. ¿Quién pintó 'La Última Cena'?" crlf)
    (printout t "   1. Leonardo da Vinci" crlf)
    (printout t "   2. Pablo Picasso" crlf)
    (printout t "   3. Vincent van Gogh" crlf)
    (printout t "   4. Claude Monet" crlf)
    (bind ?respuesta1 (pregunta-numerica "Elija una opción" 1 4))
    (if (eq ?respuesta1 1) then (bind ?puntos (+ ?puntos 1)))

    ; Segunda pregunta
    (printout t "2. ¿En qué periodo tuvo lugar el Renacimiento?" crlf)
    (printout t "   1. Siglo XIII" crlf)
    (printout t "   2. Siglo XIV al XVI" crlf)
    (printout t "   3. Siglo XVII" crlf)
    (printout t "   4. Siglo XVIII" crlf)
    (bind ?respuesta2 (pregunta-numerica "Elija una opción" 1 4))
    (if (eq ?respuesta2 2) then (bind ?puntos (+ ?puntos 1)))

    ; Tercera pregunta
    (printout t "3. ¿Qué característica define el arte barroco?" crlf)
    (printout t "   1. Simetría y simplicidad" crlf)
    (printout t "   2. Uso dramático de la luz y el movimiento" crlf)
    (printout t "   3. Representaciones abstractas" crlf)
    (printout t "   4. Colores pastel y escenas idílicas" crlf)
    (bind ?respuesta3 (pregunta-numerica "Elija una opción" 1 4))
    (if (eq ?respuesta3 2) then (bind ?puntos (+ ?puntos 1)))

    ; Cuarta pregunta
    (printout t "4. ¿Qué obra pintó Vincent van Gogh?" crlf)
    (printout t "   1. Las Meninas" crlf)
    (printout t "   2. La noche estrellada" crlf)
    (printout t "   3. El grito" crlf)
    (printout t "   4. La Gioconda" crlf)
    (bind ?respuesta4 (pregunta-numerica "Elija una opción" 1 4))
    (if (eq ?respuesta4 2) then (bind ?puntos (+ ?puntos 1)))

    ; Quinta pregunta
    (printout t "5. ¿Qué pintor es famoso por sus retratos de la corte española del siglo XVII?" crlf)
    (printout t "   1. Diego Velázquez" crlf)
    (printout t "   2. Sandro Botticelli" crlf)
    (printout t "   3. Rafael Sanzio" crlf)
    (printout t "   4. Pieter Bruegel el Viejo" crlf)
    (bind ?respuesta5 (pregunta-numerica "Elija una opción" 1 4))
    (if (eq ?respuesta5 1) then (bind ?puntos (+ ?puntos 1)))
    (printout t "Gracias por responder. Su nivel de conocimiento en arte es: " ?puntos "/5." crlf)


    ; Asignar el conocimiento acumulado al slot
    (modify ?grupo (conocimiento ?puntos))
    (retract ?state)
    (assert (estado cuarta_pregunta))
)

(defrule pregunta_diasDeVisita "Preguntar el número de días de visita"
    ?state <- (estado cuarta_pregunta)
    ?grupo <- (datos_grupo)
    =>
    (printout t "¿Cuántos días desea visitar el museo? (Introduzca un número positivo)" crlf)
    (bind ?dias (pregunta-numerica "Ingrese el número de días" 1 100)) 
    (modify ?grupo (dias ?dias))
    (retract ?state)
    (assert (estado quinta_pregunta))
)

(defrule pregunta_horasVisita "Preguntar la cota superior de horas de visita diaria"
    ?state <- (estado quinta_pregunta)
    ?grupo <- (datos_grupo)
    =>
    (printout t "¿Cuántas horas como máximo desea visitar el museo por día? (Introduzca un número entre 1 y 12)" crlf)
    (bind ?horas (pregunta-numerica "Ingrese el número de horas por día" 1 12)) 
    
    (modify ?grupo (horas ?horas))
    (retract ?state)
    (assert (estado sexta_pregunta))
    (focus MAIN)
)

(set-current-module preguntas-preferencias)
(defrule pregunta_pintorFavorito "Preguntar por los pintores favoritos"
    ?state <- (estado sexta_pregunta)
    ?preferencias <- (preferencias_grupo)
    ?pintores_raw <- (find-all-instances-of-class Pintor)
    =>
    (printout t "Por favor, seleccione los autores favoritos de la lista. Ingrese los números separados por espacios si desea seleccionar varios:" crlf)
    
    (bind ?pintores (create$))
    (foreach ?pintor ?pintores_raw
        (bind ?pintores (create$ ?pintores (send ?pintor get Nombre)))
    )

    (bind ?count 0)
    (foreach ?autor ?pintores
        (bind ?count (+ ?count 1))
        (printout t "   " ?count ". " ?autor crlf)
    )
    
    (bind ?selecciones (pregunta-multiseleccion "Seleccione los autores por número separados por espacios"))

    (bind ?pintores-fav (create$))
    (foreach ?idx ?selecciones
        (bind ?pintores-fav (create$ ?pintores-fav (nth$ ?idx ?pintores)))
    )

    (modify ?preferencias (pintores_favoritos ?pintores-fav))
    (retract ?state)
    (assert (estado septima_pregunta))
)

(defrule pregunta_tematicaFavorita "Preguntar temáticas favoritas"
    ?state <- (estado septima_pregunta)
    ?obras <- (find-all-instances-of-class Cuadro)  ; Obtiene todas las obras de arte
    ?preferencias <- (preferencias_grupo)             ; Encuentra el hecho de preferencias_grupo
    =>
    (printout t "Por favor, seleccione las temáticas favoritas de la lista. Ingrese los números separados por espacios si desea seleccionar varias:" crlf)
    
    (bind ?tematicas (create$))
    (foreach ?obra ?obras
        (bind ?tematicas (create$ ?tematicas (send ?obra get Tematica)))
    )
    (bind ?tematicas-unicas (remove-duplicates$ ?tematicas)) ; Eliminar duplicados

    (bind ?count 0)
    (foreach ?tematica ?tematicas-unicas
        (bind ?count (+ ?count 1))
        (printout t "   " ?count ". " ?tematica crlf)
    )

    (bind ?selecciones (pregunta-multiseleccion "Seleccione las temáticas por número separadas por espacios"))

    ; Construimos ?tematicas-fav según las selecciones
    (bind ?tematicas-fav (create$))
    (foreach ?idx ?selecciones
        (bind ?tematicas-fav (create$ ?tematicas-fav (nth$ ?idx ?tematicas-unicas)))
    )

    (modify ?preferencias (tematicas_favoritas ?tematicas-fav))
    (retract ?state)
    (assert (estado octava_pregunta))
)

(defrule pregunta_estiloFavorito "Preguntar estilos favoritos"
    ?state <- (estado octava_pregunta)
    ?obras <- (find-all-instances-of-class Cuadro)
    ?preferencias <- (preferencias_grupo)
    =>
    (bind ?estilos (create$))
    (foreach ?obra ?obras
        (bind ?estilos (create$ ?estilos (send ?obra get Estilo)))
    )
    (bind ?estilos-unicos (remove-duplicates$ ?estilos))

    (printout t "Por favor, seleccione los estilos favoritos de la lista. Ingrese los números separados por espacios si desea seleccionar varios:" crlf)
    
    (bind ?count 0)
    (foreach ?estilo ?estilos-unicos
        (bind ?count (+ ?count 1))
        (printout t "   " ?count ". " ?estilo crlf)
    )

    (bind ?selecciones (pregunta-multiseleccion "Seleccione los estilos por número separados por espacios"))

    (bind ?estilos-fav (create$))
    (foreach ?idx ?selecciones
        (bind ?estilos-fav (create$ ?estilos-fav (nth$ ?idx ?estilos-unicos)))
    )

    (modify ?preferencias (estilos_favoritos ?estilos-fav))
    (retract ?state)
    (assert (estado novena_pregunta))
)

(defrule pregunta_epocaFavorita "Preguntar épocas favoritas"
    ?state <- (estado novena_pregunta)
    ?obras <- (find-all-instances-of-class Cuadro)
    ?preferencias <- (preferencias_grupo)
    =>
    (bind ?epocas (create$))
    (foreach ?obra ?obras
        (bind ?epocas (create$ ?epocas (send ?obra get Epoca)))
    )
    (bind ?epocas-unicas (remove-duplicates$ ?epocas))

    (printout t "Por favor, seleccione las épocas favoritas de la lista. Ingrese los números separados por espacios si desea seleccionar varias:" crlf)
    
    (bind ?count 0)
    (foreach ?epoca ?epocas-unicas
        (bind ?count (+ ?count 1))
        (printout t "   " ?count ". " ?epoca crlf)
    )

    (bind ?selecciones (pregunta-multiseleccion "Seleccione las épocas por número separados por espacios"))

    (bind ?epocas-fav (create$))
    (foreach ?idx ?selecciones
        (bind ?epocas-fav (create$ ?epocas-fav (nth$ ?idx ?epocas-unicas)))
    )

    (modify ?preferencias (epocas_favoritas ?epocas-fav))
    (retract ?state)
    (focus MAIN)
)

(defrule MAIN::imprimir-datos-recolectados
    "Imprime todos los datos recolectados del usuario"
    =>
    (printout t crlf "----------------------------------------------------------" crlf)
    (printout t "Resumen de datos recolectados:" crlf)
    (printout t "----------------------------------------------------------" crlf)

    ;; Datos del grupo
    (foreach ?dato (find-all-facts ((?f datos_grupo)) TRUE)
        (printout t "Nombre: " (fact-slot-value ?dato nombre) crlf)
        (printout t "Tipo de Visitantes: " (fact-slot-value ?dato tipo) crlf)
        (printout t "Conocimiento en Arte: " (fact-slot-value ?dato conocimiento) "/5" crlf)
        (printout t "Días de Visita: " (fact-slot-value ?dato dias) crlf)
        (printout t "Horas máximas por día: " (fact-slot-value ?dato horas) crlf)
    )

    ;; Preferencias del grupo
    (foreach ?pref (find-all-facts ((?f preferencias_grupo)) TRUE)
        (printout t "Autores favoritos: " (fact-slot-value ?pref pintores_favoritos) crlf)
        (printout t "Temáticas favoritas: " (fact-slot-value ?pref tematicas_favoritas) crlf)
        (printout t "Estilos favoritos: " (fact-slot-value ?pref estilos_favoritos) crlf)
        (printout t "Épocas favoritas: " (fact-slot-value ?pref epocas_favoritas) crlf)
    )

    ;; Fin del resumen
    (printout t "----------------------------------------------------------" crlf)
    (printout t "Fin de los datos recolectados." crlf crlf)
)