;;; ---------------------------------------------------------
;;; Museo.clp
;;; Translated by owl2clips
;;; Translated to CLIPS from ontology Museo.ttl
;;; :Date 27/11/2024 16:20:14

(defclass Visitantes
    (is-a USER)
    (role concrete)
    (pattern-match reactive)
    ;;; 1 - Poco conocimiento ; 10 - Conocimiento completo
    (multislot ConocimientoArte
        (type INTEGER)
        (create-accessor read-write))
    (multislot DiasDeVisita
        (type INTEGER)
        (create-accessor read-write))
    (multislot DuracionVisita
        (type INTEGER)
        (create-accessor read-write))
    (multislot TipoDeVisitantes
        (type STRING)
        (create-accessor read-write))
    (multislot id
        (type INTEGER)
        (create-accessor read-write))
    (multislot nombre
        (type STRING)
        (create-accessor read-write))
    (multislot preferencias
        (type STRING)
        (create-accessor read-write))
)

(defclass Ni%C3%B1o
    (is-a Visitantes)
    (role concrete)
    (pattern-match reactive)
)

(defclass Museo
    (is-a USER)
    (role concrete)
    (pattern-match reactive)
    (multislot id
        (type INTEGER)
        (create-accessor read-write))
    (multislot nombre
        (type STRING)
        (create-accessor read-write))
)

(defclass ObrasDeArte
    (is-a USER)
    (role concrete)
    (pattern-match reactive)
    (multislot pintada_por
        (type INSTANCE)
        (create-accessor read-write))
    (multislot ubicada_en
        (type INSTANCE)
        (create-accessor read-write))
    (multislot Epoca
        (type STRING)
        (create-accessor read-write))
    (multislot Sala
        (type INTEGER)
        (create-accessor read-write))
    (multislot anyCreacion
        (type INTEGER)
        (create-accessor read-write))
    (multislot complejidad
        (type INTEGER)
        (create-accessor read-write))
    (multislot dimensiones
        (type STRING)
        (create-accessor read-write))
    (multislot estilo
        (type STRING)
        (create-accessor read-write))
    (multislot id
        (type INTEGER)
        (create-accessor read-write))
    (multislot nombre
        (type STRING)
        (create-accessor read-write))
    (multislot relevancia
        (type INTEGER)
        (create-accessor read-write))
    (multislot tematica
        (type STRING)
        (create-accessor read-write))
)

(defclass Rz2vZwaBtLRvgVjqNRbL7T
    (is-a USER)
    (role concrete)
    (pattern-match reactive)
    (multislot Ha_pintado
        (type INSTANCE)
        (create-accessor read-write))
    (multislot Epoca
        (type STRING)
        (create-accessor read-write))
    (multislot id
        (type INTEGER)
        (create-accessor read-write))
    (multislot nacionalidad
        (type STRING)
        (create-accessor read-write))
    (multislot nombre
        (type STRING)
        (create-accessor read-write))
    ;;; Un pintor puede tener varios periodosPictoricos y los ponemos todos en forma string
    (multislot periodosPictoricos
        (type STRING)
        (create-accessor read-write))
)

(defclass Sala
    (is-a USER)
    (role concrete)
    (pattern-match reactive)
    (multislot id
        (type INTEGER)
        (create-accessor read-write))
    (multislot nombre
        (type STRING)
        (create-accessor read-write))
)

(definstances instances
)
