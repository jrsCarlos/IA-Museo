(defmodule MAIN
    (import DataBase ?ALL)
    (import Templates ?ALL)
    (import TipoPregunta ?ALL)
    (import PreguntasUsuario ?ALL)
    (import PlanearItinerario ?ALL)
    (export ?ALL)
)

(defrule MAIN::Inicio
	(declare (salience 10))
	=>
  	(printout t crlf)  	
    (printout t "-------------------------------------------------------------------------------" crlf)
    (printout t "                                  ¡Bienvenid@!                                 " crlf)
	(printout t "A continuación se le formularán una serie de preguntas sus datos y preferencias" crlf)
    (printout t "     artísticas para poder organizarle una visita guiada por nuestro museo     " crlf)
    (printout t "-------------------------------------------------------------------------------" crlf)
    (printout t crlf)

    ; Ceamos las variables donde almacenaremos la informacion del usuario
    (assert (datos-grupo))
    (assert (preferencias-grupo))

    ; Iniciamos el flujo de preguntas
    (assert (estado (pregunta-1 1)))
    (focus PreguntasUsuario)
    ; Hacer make-instance de visitante
    ;Crear una clase visita que tenga atributo multislot dias que cada dia almacena un conjunto de cuadros
)

(defrule MAIN::GenerarRecorrido
    ?grupo <- (datos-grupo)
    ?preferencias <- (preferencias-grupo)
    =>
    ; Creamos la instancia del itinerario
    (make-instance [ItinerarioMuseo] of Itinerario
        (DiasDeVisita (fact-slot-value ?grupo dias))
        (Compuesto_de (create$))
    )

    ; Creamos la instancia del visitante
    (make-instance [Usuario] of Visitante
        (Nombre (fact-slot-value ?grupo nombre))
        (Tipo (fact-slot-value ?grupo tipo))
        (Conocimiento (fact-slot-value ?grupo conocimiento))
        (Preferencias (create$ (fact-slot-value ?preferencias pintores)
                               (fact-slot-value ?preferencias tematicas)
                               (fact-slot-value ?preferencias estilos)
                               (fact-slot-value ?preferencias epocas))
        )
        (Realiza nil)
    )
    
    (focus PlanearItinerario)
)

(defrule imprimir-itinerario
    =>
    (printout t "=============================================================================" crlf)
    (printout t "                             DATOS DEL VISITANTE                             " crlf)
    (printout t "=============================================================================" crlf)

    (printout t crlf)
    (printout t "Nombre: " (send [Usuario] get-Nombre) crlf)
    (printout t "Tipo de visitante: " (send [Usuario] get-Tipo) crlf)
    (printout t "Preferencias: " (send [Usuario] get-Preferencias) crlf)
    (printout t crlf)

    (printout t "=============================================================================" crlf)
    (printout t "                          ITINERARIO PERSONALIZADO                           " crlf)
    (printout t "=============================================================================" crlf)

    (bind ?dias (send [ItinerarioMuseo] get-DiasDeVisita))

    (printout t crlf)
    (printout t "Días de visita: " ?dias crlf)
    (printout t crlf)

    (bind ?visitas (send [ItinerarioMuseo] get-Compuesto_de))
    (bind ?i 1)

    (foreach ?visita ?visitas
        (printout t crlf)
        (printout t "____________________________________DIA-" ?i "____________________________________" crlf)
        (printout t crlf)

        (printout t "Salas a visitar: " (send ?visita get-Realizada_en) crlf)
        (printout t "Tiempo estimado de la visita: " (round (send ?visita get-Tiempo)) " minutos" crlf)
        (printout t crlf)

        (printout t "                      ========== CUADROS A VISITAR ==========                     " crlf)
        (printout t crlf)

        (bind ?observaciones (send ?visita get-Se_realizan))
        (bind ?idx-cuadro 1)

        (foreach ?obs ?observaciones
            (bind ?cuadro (send ?obs get-Cuadro))
            (bind ?tiempo (send ?obs get-Tiempo))

            (printout t "Cuadro-" ?idx-cuadro ":" crlf)
            (printout t " -Titulo: " (send ?cuadro get-Titulo) crlf)
            (printout t " -Autor: " (send (send ?cuadro get-Pintado_por) get-Nombre) crlf)
            (printout t " -Año de creación: " (send ?cuadro get-AnyCreacion) crlf)
            (printout t " -Estilo: " (send ?cuadro get-Estilo) crlf)
            (printout t " -Epoca: " (send ?cuadro get-Epoca) crlf)
            (printout t " -Tematica: " (send ?cuadro get-Tematica) crlf)
            (printout t " -Dimensiones: " (send ?cuadro get-Dimensiones) crlf)
            (printout t " -Tiempo estimado de observación: " (round ?tiempo) " minutos" crlf)
            (printout t crlf)


            (bind ?idx-cuadro (+ ?idx-cuadro 1))
        )
        (bind ?i (+ ?i 1))
    )
)
