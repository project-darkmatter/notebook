(in-package :cl-user)
(defpackage darkmatter/notebook/domains/cell
  (:use :cl)
  (:export :cell-entity
           :cell-id
           :make-code-cell-entity
           :code-cell-entity
           :code-cell-source
           :code-cell-execution-count
           :code-cell-collapsed
           :code-cell-autoscroll
           :code-cell-outputs
           :make-note-cell-entity
           :note-cell-entity
           :note-cell-format
           :note-cell-source
           :make-raw-cell-entity
           :raw-cell-entity
           :raw-cell-format
           :raw-cell-source
           :output-id
           :output-entity
           :make-stream-output-entity
           :stream-output-entity
           :stream-output-stream
           :stream-output-source
           :make-display-data-output-entity
           :display-data-output-entity
           :display-data-output-data
           :display-data-output-metadata
           :make-execute-result-output-entity
           :execute-result-output-entity
           :execute-result-output-execution-count
           :execute-result-output-data
           :execute-result-output-metadata
           :make-error-output-entity
           :error-output-entity
           :error-output-name
           :error-output-value
           :error-output-traceback))
(in-package :darkmatter/notebook/domains/cell)

(deftype cell-id () 'integer)
(defstruct (cell-entity (:conc-name cell-))
  (id 0 :type cell-id))

(deftype %code-cell-source () '(or string list))
(deftype %code-cell-execution-count () '(or integer null))
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

(deftype output-id () 'integer)
(defstruct (output-entity (:conc-name output-))
  (id 0 :type output-id))

(deftype %stream-output-stream () '(member :stdout :stderr))
(deftype %stream-output-source () 'list)
(defstruct (stream-output-entity (:include output-entity)
                                 (:conc-name stream-output-))
  (stream :stdout :type %stream-output-stream)
  (source nil :type %stream-output-source))

(deftype %display-data-output-data () 'list)
(deftype %display-data-output-metadata () 'list)
(defstruct (display-data-output-entity (:include output-entity)
                                       (:conc-name display-data-output-))
  (data nil :type %display-data-output-data)
  (metadata nil :type %display-data-output-metadata))

(deftype %execute-result-output-execution-count () 'integer)
(deftype %execute-result-output-data () 'list)
(deftype %execute-result-output-metadata () 'list)
(defstruct (execute-result-output-entity (:include output-entity)
                                         (:conc-name execute-result-output-))
  (execution-count 0 :type %execute-result-output-execution-count)
  (data nil :type %execute-result-output-data)
  (metadata nil :type %execute-result-output-metadata))

(deftype %error-output-name () 'string)
(deftype %error-output-value () 'string)
(deftype %error-output-traceback () 'list)
(defstruct (error-output-entity (:include output-entity)
                                (:conc-name error-output-))
  (name "" :type %error-output-name)
  (value "" :type %error-output-value)
  (traceback nil :type %error-output-traceback))
