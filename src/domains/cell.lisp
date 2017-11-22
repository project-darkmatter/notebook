(in-package :cl-user)
(defpackage darkmatter/notebook/domains/cell
  (:use :cl)
  (:export :cell-entity
           :cell-id
           :code-cell-entity
           :code-cell-source
           :code-cell-execution-count
           :code-cell-collapsed
           :code-cell-autoscroll
           :code-cell-outputs
           :note-cell-entity
           :note-cell-format
           :note-cell-source
           :raw-cell-entity
           :raw-cell-format
           :raw-cell-source))
(in-package :darkmatter/notebook/domains/cell)

(deftype cell-id () 'integer)
(defstruct (cell-entity (:conc-name cell-))
  (id 0 :type cell-id))

(deftype %code-cell-source () 'string)
(deftype %code-cell-execution-count () 'integer)
(deftype %code-cell-collapsed () 'boolean)
(deftype %code-cell-autoscroll () 'boolean)
(deftype %code-cell-outputs () 'list)
(defstruct (code-cell-entity (:include cell-entity)
                             (:conc-name code-cell-))
  (source "" :type %code-cell-source)
  (execution-count 0 :type %code-cell-execution-count)
  (collapsed nil :type %code-cell-collapsed)
  (autoscroll nil :type %code-cell-autoscroll)
  (outputs nil :type %code-cell-outputs))

(deftype %note-cell-format () '(member :markdown :asciidoc :latex))
(deftype %note-cell-source () 'list)
(defstruct (note-cell-entity (:include cell-entity)
                             (:conc-name note-cell-))
  (format :markdown :type %note-cell-format)
  (source nil :type %note-cell-source))

(deftype %raw-cell-format () 'string)
(deftype %raw-cell-source () 'list)
(defstruct (raw-cell-entity (:include cell-entity)
                            (:conc-name raw-cell-))
  (format "" :type %raw-cell-format)
  (source nil :type %raw-cell-source))
