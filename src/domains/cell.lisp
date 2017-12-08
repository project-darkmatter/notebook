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
           :raw-cell-source
           :output-id
           :output-entity
           :stream-output-entity
           :stream-output-stream
           :stream-output-source
           :display-data-output-entity
           :display-data-output-data
           :display-data-output-metadata
           :execute-result-output-entity
           :execute-result-output-execution-count
           :execute-result-output-data
           :execute-result-output-metadata
           :error-output-entity
           :error-output-name
           :error-output-value
           :error-output-traceback))
(in-package :darkmatter/notebook/domains/cell)

(deftype cell-id () 'integer)
(defclass cell-entity ()
  ((id :initarg :id
       :initform 0
       :type cell-id)))

(deftype %code-cell-source () '(or string list))
(deftype %code-cell-execution-count () '(or integer null))
(deftype %code-cell-collapsed () 'boolean)
(deftype %code-cell-autoscroll () 'boolean)
(deftype %code-cell-outputs () 'list)
(defclass code-cell-entity (cell-entity)
  ((source :initarg :source
           :initform ""
           :type %code-cell-source
           :reader code-cell-source)
   (execution-count :initarg :execution-count
                    :initform 0
                    :type %code-cell-execution-count
                    :reader code-cell-execution-count)
   (collapsed :initarg :collapsed
              :initform nil
              :type %code-cell-collapsed
              :reader code-cell-collapsed)
   (autoscroll :initarg :autoscroll
               :initform nil
               :type %code-cell-autoscroll
               :reader code-cell-autoscroll)
   (outputs :initarg :outputs
            :initform nil
            :type %code-cell-outputs
            :reader code-cell-outputs)))
(defmethod print-object ((o code-cell-entity) s)
  (with-slots (source execution-count collapsed autoscroll outputs) o
    (print-unreadable-object (o s :type t)
      (format s "~%~Tsource = ~S~%~Texecution-count = ~S~%~Tcollapsed = ~S~%~Tautoscroll = ~S~%~Toutputs = ~S"
              source execution-count collapsed autoscroll outputs))))


(deftype %note-cell-format () '(member :markdown :asciidoc :latex))
(deftype %note-cell-source () 'list)
(defclass note-cell-entity (cell-entity)
  ((format :initarg :format
           :initform :markdown
           :type %note-cell-format
           :reader note-cell-format)
   (source :initarg :source
           :initform nil
           :type %note-cell-source
           :reader note-cell-source)))
(defmethod print-object ((o note-cell-entity) s)
  (with-slots (format source) o
    (print-unreadable-object (o s :type t)
      (format s "~%~Tformat = ~S~%~Tsource = ~S"
              format source))))

(deftype %raw-cell-format () 'string)
(deftype %raw-cell-source () 'list)
(defclass raw-cell-entity (cell-entity)
  ((format :initarg :format
           :initform ""
           :type %raw-cell-format
           :reader raw-cell-format)
   (source :initarg :source
           :initform nil
           :type %raw-cell-source
           :reader raw-cell-source)))
(defmethod print-object ((o raw-cell-entity) s)
  (with-slots (format source) o
    (print-unreadable-object (o s :type t)
      (format s "~%~Tformat = ~S~%~Tsource = ~S"
              format source))))

(deftype output-id () 'integer)
(defclass output-entity ()
  ((id :initarg :id
       :initform 0
       :type output-id
       :reader output-id)))

(deftype %stream-output-stream () '(member :stdout :stderr))
(deftype %stream-output-source () 'list)
(defclass stream-output-entity (output-entity)
  ((stream :initarg :stream
           :initform :stdout
           :type %stream-output-stream
           :reader stream-output-stream)
   (source :initarg :source
           :initform nil
           :type %stream-output-source
           :reader stream-output-source)))
(defmethod print-object ((o stream-output-entity) s)
  (with-slots (stream source) o
    (print-unreadable-object (o s :type t)
      (format s "~%~Tstream = ~S~%~Tsource = ~S"
              stream source))))

(deftype %display-data-output-data () 'list)
(deftype %display-data-output-metadata () 'list)
(defclass display-data-output-entity (output-entity)
  ((data :initarg :data
         :initform nil
         :type %display-data-output-data
         :reader display-data-output-data)
   (metadata :initarg :metadata
             :initform nil
             :type %display-data-output-metadata
             :reader display-data-output-metadata)))
(defmethod print-object ((o display-data-output-entity) s)
  (with-slots (data metadata) o
    (print-unreadable-object (o s :type t)
      (format s "~%~Tdata = ~S~%~Tmetadata = ~S"
              data metadata))))

(deftype %execute-result-output-execution-count () 'integer)
(deftype %execute-result-output-data () 'list)
(deftype %execute-result-output-metadata () 'list)
(defclass execute-result-output-entity (output-entity)
  ((execution-count :initarg :execution-count
                    :initform 0
                    :type %execute-result-output-execution-count
                    :reader execute-result-output-execution-count)
   (data :initarg :data
         :initform nil
         :type %execute-result-output-data
         :reader execute-result-output-data)
   (metadata :initarg :metadata
             :initform nil
             :type %execute-result-output-metadata
             :reader execute-result-output-metadata)))
(defmethod print-object ((o execute-result-output-entity) s)
  (with-slots (execution-count data metadata) o
    (print-unreadable-object (o s :type t)
      (format s "~%~T execution-count = ~S~%~Tdata = ~S~%~Tmetadata = ~S"
              execution-count data metadata))))

(deftype %error-output-name () 'string)
(deftype %error-output-value () 'string)
(deftype %error-output-traceback () 'list)
(defclass error-output-entity (output-entity)
  ((name :initarg :data
         :initform nil
         :type %error-output-name
         :reader error-output-name)
   (value :initarg :value
          :initform nil
          :type %error-output-value
          :reader error-output-value)
   (traceback :initarg :traceback
              :initform nil
              :type %error-traceback
              :reader error-traceback)))
(defmethod print-object ((o error-output-entity) s)
  (with-slots (name value traceback) o
    (print-unreadable-object (o s :type t)
      (format s "~%~Terror = ~S~%~Tvalue = ~S~%~Ttraceback = ~S"
              name value traceback))))

