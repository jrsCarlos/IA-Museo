 ; Cargamos todas las instancias

(defmodule main 
    (import templates ?ALL) 
    (import tipo-preguntas ?ALL)
    (export ?ALL))

(defrule main::inicializacion "Iniciamos el programa"
    (declare (salience 10))
    =>
    (printout t crlf)
    (printout t "----------------------------------------------------------" crlf)
    (printout t "¡Bienvenido! A continuacion se le formularan una serie de preguntas para poder recomendarle una visita adecuada a sus preferencias." crlf)
    (printout t "----------------------------------------------------------" crlf)
    (printout t crlf)
    (assert (FasePreguntas1)) ; Hecho inicial
)

(defrule main::pregunta_nombre "Preguntar el nombre al usuario"
    (FasePreguntas1) ; Condición: FasePreguntas1 debe existir
    =>
    (printout t "Por favor, introduzca su nombre: " crlf)
    (bind ?nombre (read)) ; Leer el nombre
    (assert (datos_grupo (nombre ?nombre))) ; Guardar el nombre
    (printout t "¡Gracias, " ?nombre "! Continuemos con las preguntas." crlf)
    (retract (FasePreguntas1)) ; Eliminar FasePreguntas1
    (assert (FasePreguntas2)) ; Pasar a la siguiente fase
)

; Aqui no se podria utilizar pregunta-opciones??
(defrule main::pregunta_tipo "Preguntar el tamaño del grupo"
    (FasePreguntas2)
	?grupo <- (datos_grupo (tipoDeVisitantes ?))
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
    (assert (datos_grupo (tipoDeVisitantes ?tipo)))
    (retract (FasePreguntas2))
    (assert (FasePreguntas3))
)

(defrule pregunta_conocimiento "Establecer el conocimiento del visitante"
    (FasePreguntas3)
    ?grupo <- (datos_grupo (conocimiento ?))
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

    ; Asignar el conocimiento acumulado al slot
    (assert (datos_grupo (conocimiento ?puntos)))

    (printout t "Gracias por responder. Su nivel de conocimiento en arte es: " ?puntos "/5." crlf)
    (retract (FasePreguntas3))
    (assert (FasePreguntas4))
); Xinxiang me han molao las preguntas

(defrule pregunta_diasDeVisita "Preguntar el número de días de visita"
    (FasePreguntas4)
    ?grupo <- (datos_grupo (dias ?))
    =>
    (printout t "¿Cuántos días desea visitar el museo? (Introduzca un número positivo)" crlf)
    (bind ?dias (pregunta-numerica "Ingrese el número de días" 1 100)) 
    (modify ?grupo (dias ?dias))
    (retract (FasePreguntas4))
    (assert (FasePreguntas5))
)

; Porque aqui haces modify y en las otras reglas haces assert?
(defrule pregunta_horasVisita "Preguntar la cota superior de horas de visita diaria"
    (FasePreguntas5)
    ?grupo <- (datos_grupo (horas ?))
    =>
    (printout t "¿Cuántas horas como máximo desea visitar el museo por día? (Introduzca un número entre 1 y 12)" crlf)
    (bind ?horas (pregunta-numerica "Ingrese el número de horas por día" 1 12)) 
    (modify ?grupo (horas ?horas))
    (retract (FasePreguntas5))
    (assert (FasePreguntas6))
)

(defrule pregunta_pintorFavorito "Preguntar por los pintores favoritos"
    (FasePreguntas6)
    ?pintores <- (find-all-instances-of-class Pintor) ; Obtiene todos los pintores
    =>
    (printout t "Por favor, seleccione los autores favoritos de la lista. Ingrese los números separados por espacios si desea seleccionar varios:" crlf)
    (foreach ?pintor (create$ ?pintores) ; Recorre los pintores para mostrar sus nombres
        (printout t "   " (+ 1 ?index) ". " (send ?pintor get Nombre) crlf)
    )
    (bind ?selecciones (pregunta-multiseleccion "Seleccione los autores por número separados por espacios"))
    (bind ?autores (create$ (foreach ?idx ?selecciones
                                     (nth$ ?idx ?pintores)))) ; Traduce los números a instancias
    (assert (preferencias_grupo (autores_favoritos ?autores)))
)

(defrule pregunta_tematicaFavorita "Preguntar temáticas favoritas"
    (declare (salience 3))
    ?obras <- (find-all-instances-of-class Cuadro) ; Obtiene todas las obras de arte
    ?pref-grupo <- (preferencias_grupo) ; Encuentra el hecho de preferencias_grupo
    =>
    (bind ?tematicas (create$ (foreach ?obra ?obras (send ?obra get Tematica)))) 
    (bind ?tematicas-unicas (remove-duplicates$ ?tematicas)) ; Eliminar duplicados

    (printout t "Por favor, seleccione las temáticas favoritas de la lista. Ingrese los números separados por espacios si desea seleccionar varias:" crlf)
    (foreach ?tematica ?tematicas-unicas
        (printout t "   " (+ 1 ?index) ". " ?tematica crlf)
    )

    (bind ?selecciones (pregunta-multiseleccion "Seleccione las temáticas por número separadas por espacios"))
    (bind ?tematicas-fav (create$ (foreach ?idx ?selecciones
                                           (nth$ ?idx ?tematicas-unicas)))) ; Traduce los números a temáticas

    (modify ?pref-grupo (tematicas_obras_fav ?tematicas-fav))
)

(defrule pregunta_estiloFavorito "Preguntar estilos favoritos"
    (declare (salience 2))
    ?obras <- (find-all-instances-of-class Cuadro) ; Obtiene todas las obras de arte
    ?pref-grupo <- (preferencias_grupo) ; Encuentra el hecho de preferencias_grupo
    =>
    (bind ?estilos (create$ (foreach ?obra ?obras (send ?obra get Estilo)))) 
    (bind ?estilos-unicos (remove-duplicates$ ?estilos)) ; Eliminar duplicados

    (printout t "Por favor, seleccione los estilos favoritos de la lista. Ingrese los números separados por espacios si desea seleccionar varios:" crlf)
    (foreach ?estilo ?estilos-unicos
        (printout t "   " (+ 1 ?index) ". " ?estilo crlf)
    )

    (bind ?selecciones (pregunta-multiseleccion "Seleccione los estilos por número separados por espacios"))
    (bind ?estilos-fav (create$ (foreach ?idx ?selecciones
                                         (nth$ ?idx ?estilos-unicos)))) ; Traduce los números a estilos

    (modify ?pref-grupo (estilos_favoritos ?estilos-fav))
)

(defrule pregunta_epocaFavorita "Preguntar épocas favoritas"
    (declare (salience 1))
    ?obras <- (find-all-instances-of-class Cuadro) ; Obtiene todas las obras de arte
    ?pref-grupo <- (preferencias_grupo) ; Encuentra el hecho de preferencias_grupo
    =>
    (bind ?epocas (create$ (foreach ?obra ?obras (send ?obra get Epoca)))) 
    (bind ?epocas-unicas (remove-duplicates$ ?epocas)) ; Eliminar duplicados

    (printout t "Por favor, seleccione las épocas favoritas de la lista. Ingrese los números separados por espacios si desea seleccionar varias:" crlf)
    (foreach ?epoca ?epocas-unicas
        (printout t "   " (+ 1 ?index) ". " ?epoca crlf)
    )

    (bind ?selecciones (pregunta-multiseleccion "Seleccione las épocas por número separados por espacios"))
    (bind ?epocas-fav (create$ (foreach ?idx ?selecciones
                                        (nth$ ?idx ?epocas-unicas)))) ; Traduce los números a épocas

    (modify ?pref-grupo (epocas_favoritas ?epocas-fav))
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