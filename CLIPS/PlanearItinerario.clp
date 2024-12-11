(defmodule PlanearItinerario 
    (import DataBase ?ALL)
    (import Templates ?ALL)
    (import TipoPregunta ?ALL)
    (export ?ALL)
)

; Selecionamos los cuadros que coincidan con las preferencias del usuario
(defrule filtrar-cuadros
    ?preferencias <- (preferencias-grupo)
    =>
    ; Anadiremos los cuadros al itinerario en el orden de las salas
    (bind ?salas (find-all-instances ((?inst Sala)) TRUE))
    ; En esta varible guardaremos los cuadros que recomendaremos
    (bind ?cuadros (create$))

    ; Recorremos todas las sala anadiendo solo aquellos cuadros que
    ; coincidan con las preferencias del usuario
    (foreach ?sala ?salas
        (bind ?cuadros-sala (send ?sala get-Contiene))
        (foreach ?cuadro ?cuadros-sala
            (bind ?pintor (send (send ?cuadro get-Pintado_por) get-Nombre))
            (bind ?tematica (send ?cuadro get-Tematica))
            (bind ?estilo (send ?cuadro get-Estilo))
            (bind ?epoca (send ?cuadro get-Epoca))
            ; Comprobamos si el cuadro coincide con alguna preferencia y no esta en ?cuadros
            (if (and (or (member$ ?pintor (fact-slot-value ?preferencias pintores))
                         (member$ ?tematica (fact-slot-value ?preferencias tematicas))
                         (member$ ?estilo (fact-slot-value ?preferencias estilos))
                         (member$ ?epoca (fact-slot-value ?preferencias epocas)))
                     (not (member$ ?cuadro ?cuadros)))
            then (bind ?cuadros (create$ ?cuadros ?cuadro))
            )
        )
    )

    (assert (cuadros-recomendados (create$ ?cuadros)))
)

; Derivamos la complejidad de los cuadros seleccionados en base a sus dimensiones
(defrule derivar-complejidad
    (cuadros-recomendados $?cuadros)
    =>
    (foreach ?cuadro ?cuadros
        (bind ?dimensiones (send ?cuadro get-Dimensiones))
        (bind ?complejidad (derivar-complejidad ?dimensiones))
        (send ?cuadro put-Complejidad ?complejidad)
    )
)

; Calculamos el tiempo por cuadro
(defrule calcular-tiempo
    (cuadros-recomendados $?cuadros)
    ?grupo <- (datos-grupo)
    =>
    ; Ponderaremos en el tiempo de visita en funcion del tipo de grupo
    (bind ?ponderacion 1)   ; Por defecto, podenración para una persona
    (bind ?tipo (fact-slot-value ?grupo tipo))
    (if (eq ?tipo "Familia") then (bind ?ponderacion 0.6))
    (if (eq ?tipo "GrupoPequeno") then (bind ?ponderacion 0.8))
    (if (eq ?tipo "GrupoGrande") then (bind ?ponderacion 0.5))
    
    (bind ?conocimiento (fact-slot-value ?grupo conocimiento)) ; Conocimiento del grupo
    (bind ?puntos-totales 0)    ; La suma de los puntos de todos los cuadros
    (bind ?puntos (create$))    ; Cada elemento representa los puntos del i-esimo cuadro

    ; Calculamos los puntos para cada cuadro
    (foreach ?cuadro ?cuadros
        (bind ?complejidad (send ?cuadro get-Complejidad))
        (bind ?relevancia (send ?cuadro get-Relevancia))

        ; Cuanto mas conocimiento tenga el grupo, menos tiempo necesitara para ver el cuadro
        (bind ?puntos-aux (/ (float (log10 ?complejidad)) (float (+ 1 ?conocimiento)))) ; = complejidad / (conocimiento + 1)    
        (bind ?puntos-aux (* ?relevancia ?puntos-aux ?ponderacion))
        
        ; Anadimos los puntos del cuadro a la lista de puntos de todos los cuadros
        (bind ?puntos (create$ ?puntos ?puntos-aux))
        ; Acumulamos los puntos
        (bind ?puntos-totales (+ ?puntos-totales ?puntos-aux))
    )

    ;;; NORMALIZAMOS LOS PUNTOS ;;;

    ; Calculamos el tiempo total
    (bind ?numDias (fact-slot-value ?grupo dias))
    (bind ?horasDiarias (fact-slot-value ?grupo horas))
    (bind ?tiempo-total (* ?numDias ?horasDiarias 60)) ; Tiempo total en minutos

    ; Calculamos los puntos relativos
    (bind ?tiempos-normalizados (create$))
    (foreach ?puntuaje ?puntos
        (bind ?puntuaje-relativo (/ (float ?puntuaje) (float ?puntos-totales)))
        (bind ?puntuaje-normalizado (* ?puntuaje-relativo ?tiempo-total))
        (bind ?tiempos-normalizados (create$ ?tiempos-normalizados ?puntuaje-normalizado))
    )

    ; Creamos las instancias de Observacion
    (loop-for-count (?i (length$ ?cuadros)) do
        (bind ?cuadro (nth$ ?i ?cuadros))
        (bind ?tiempo (nth$ ?i ?tiempos-normalizados))

        (bind ?id-observacion (gensym))
        (make-instance ?id-observacion of Observacion
            (Cuadro ?cuadro)
            (Tiempo ?tiempo)
        )
    )
)

(defrule repartir-obervaciones
    ?grupo <- (datos-grupo)
    =>
    (bind ?observaciones (find-all-instances ((?inst Observacion)) TRUE))
    (bind ?horas-max (fact-slot-value ?grupo horas))

    (bind ?horas-ocupadas 0)
    (bind ?salas-visitadas (create$))
    (bind ?numDias (fact-slot-value ?grupo dias))

    (bind ?particiones (create$))
    (bind ?particion (create$))

    (bind ?idx 1)
    (bind ?observacion (nth$ ?idx ?observaciones))
    (bind ?tiempo (send ?observacion get-Tiempo))
    (while (<= (+ ?horas-ocupadas ?tiempo) ?horas-max) do
        ; Actulizamos las horas ocupadas
        (bind ?horas-ocupadas (+ ?horas-ocupadas ?tiempo))

        ; Guardamos la sala visitada (solo si no la hemos visitado ya)
        (bind ?cuadro (send ?observacion get-Cuadro))
        (bind ?sala (send ?cuadro get-Sala))
        (if (not (member$ ?sala ?salas-visitadas)) then
            (bind ?salas-visitadas (create$ ?salas-visitadas ?sala))
        )

        ; Anadimos la observacion a la particion
        (bind ?particion (create$ ?particion ?observacion))
        (bind ?idx (+ ?idx 1))

        (if)
        (bind ?observacion (nth$ ?idx ?observaciones))
        (bind ?tiempo (send ?observacion get-Tiempo))
    )
    (bind ?particiones (create$ ?particiones ?particion))
)
