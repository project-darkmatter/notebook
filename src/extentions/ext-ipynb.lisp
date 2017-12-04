(in-package :cl-user)
(defpackage darkmatter/notebook/extentions/ipynb
  (:use :cl)
  (:import-from :darkmatter/notebook/domains/cell
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
                :error-output-traceback)
  (:import-from :darkmatter/notebook/utils/convert
                :plist-to-hash-table)
  (:export :map-to-ipynb
           :serialize.ipynb
           :deserialize.ipynb))
(in-package :darkmatter/notebook/extentions/ipynb)

(defmethod yason:encode ((symbol symbol) &optional (stream *standard-output*))
  (yason:encode (symbol-name symbol) stream))

(deftype %ipynb.cell-type () 'string)
(deftype %ipynb.cell-metadata () 'hash-table)
(deftype %ipynb.cell-source () '(or string list))
(defstruct ipynb.cell
  (cell-type "" :type %ipynb.cell-type)
  (metadata nil :type %ipynb.cell-metadata)
  (source nil :type %ipynb.cell-source))

(defmethod yason:encode ((object ipynb.cell) &optional (stream *standard-output*))
  (yason:with-output (stream)
    (yason:with-object ()
      (yason:encode-object-element "cell_type"
        (ipynb.cell-cell-type object))
      (yason:encode-object-element "metadata"
        (ipynb.cell-metadata object))
      (yason:encode-object-element "source"
        (ipynb.cell-source object)))))

(deftype %ipynb.code-cell-execution-count () '(or integer nil))
(deftype %ipynb.code-cell-outputs () 'list)
(defstruct (ipynb.code-cell (:include ipynb.cell))
  (execution-count 0 :type %ipynb.code-cell-execution-count)
  (outputs nil :type %ipynb.code-cell-outputs))

(defmethod yason:encode ((object ipynb.code-cell) &optional (stream *standard-output*))
  (yason:with-output (stream)
    (yason:with-object ()
      (yason:encode-object-element "cell_type"
        (ipynb.code-cell-cell-type object))
      (yason:encode-object-element "execution_count"
        (ipynb.code-cell-execution-count object))
      (yason:encode-object-element "metadata"
        (ipynb.code-cell-metadata object))
      (yason:encode-object-element "source"
        (ipynb.code-cell-source object))
      (yason:encode-object-element "outputs"
        (ipynb.code-cell-outputs object)))))

(defstruct (ipynb.markdown-cell (:include ipynb.cell)))

(defmethod yason:encode ((object ipynb.markdown-cell) &optional (stream *standard-output*))
  (yason:with-output (stream)
    (yason:with-object ()
      (yason:encode-object-element "cell_type"
        (ipynb.markdown-cell-cell-type object))
      (yason:encode-object-element "metadata"
        (ipynb.markdown-cell-metadata object))
      (yason:encode-object-element "source"
        (ipynb.markdown-cell-source object)))))

(defstruct (ipynb.raw-cell (:include ipynb.cell)))

(defmethod yason:encode ((object ipynb.raw-cell) &optional (stream *standard-output*))
  (yason:with-output (stream)
    (yason:with-object ()
      (yason:encode-object-element "cell_type"
        (ipynb.raw-cell-cell-type object))
      (yason:encode-object-element "metadata"
        (ipynb.raw-cell-metadata object))
      (yason:encode-object-element "source"
        (ipynb.raw-cell-source object)))))

(deftype %ipynb.code-cell-output-type () 'string)
(defstruct ipynb.code-cell-output
  (output-type "" :type %ipynb.code-cell-output-type))

(deftype %ipynb.stream-output-name () 'string)
(deftype %ipynb.stream-output-text () 'list)
(defstruct (ipynb.stream-output (:include ipynb.code-cell-output))
  (name "" :type %ipynb.stream-output-name)
  (text nil :type %ipynb.stream-output-text))

(defmethod yason:encode ((object ipynb.stream-output) &optional (stream *standard-output*))
  (yason:with-output (stream)
    (yason:with-object ()
      (yason:encode-object-element "output_type"
        (ipynb.stream-output-output-type object))
      (yason:encode-object-element "name"
        (ipynb.stream-output-name object))
      (yason:encode-object-element "text"
        (ipynb.stream-output-text object)))))

(deftype %ipynb.display-data-data () 'hash-table)
(deftype %ipynb.display-data-metadata () 'hash-table)
(defstruct (ipynb.display-data (:include ipynb.code-cell-output))
  (data nil :type %ipynb.display-data-data)
  (metadata nil :type %ipynb.display-data-metadata))

(defmethod yason:encode ((object ipynb.display-data) &optional (stream *standard-output*))
  (yason:with-output (stream)
    (yason:with-object ()
      (yason:encode-object-element "output_type"
        (ipynb.display-data-output-type object))
      (yason:encode-object-element "data"
        (ipynb.display-data-data object))
      (yason:encode-object-element "metadata"
        (ipynb.display-data-metadata object)))))

(deftype %ipynb.execute-result-execution-count () 'integer)
(deftype %ipynb.execute-result-data () 'hash-table)
(deftype %ipynb.execute-result-metadata () 'hash-table)
(defstruct (ipynb.execute-result (:include ipynb.code-cell-output))
  (execution-count 0 :type %ipynb.execute-result-execution-count)
  (data nil :type %ipynb.execute-result-data)
  (metadata nil :type %ipynb.execute-result-metadata))

(defmethod yason:encode ((object ipynb.execute-result) &optional (stream *standard-output*))
  (yason:with-output (stream)
    (yason:with-object ()
      (yason:encode-object-element "output_type"
        (ipynb.execute-result-output-type object))
      (yason:encode-object-element "execution_count"
        (ipynb.execute-result-execution-count object))
      (yason:encode-object-element "data"
        (ipynb.execute-result-data object))
      (yason:encode-object-element "metadata"
        (ipynb.execute-result-metadata object)))))

(deftype %ipynb.error-output-ename () 'string)
(deftype %ipynb.error-output-evalue () 'string)
(deftype %ipynb.error-output-traceback () 'list)
(defstruct (ipynb.error-output (:include ipynb.code-cell-output))
  (ename 0 :type %ipynb.error-output-ename)
  (evalue nil :type %ipynb.error-output-evalue)
  (traceback nil :type %ipynb.error-output-traceback))

(defmethod yason:encode ((object ipynb.error-output) &optional (stream *standard-output*))
  (yason:with-output (stream)
    (yason:with-object ()
      (yason:encode-object-element "output_type"
        (ipynb.error-output-output-type object))
      (yason:encode-object-element "ename"
        (ipynb.error-output-ename object))
      (yason:encode-object-element "evalue"
        (ipynb.error-output-evalue object))
      (yason:encode-object-element "traceback"
        (ipynb.error-output-traceback object)))))

(deftype %ipynb-format.metadata () 'hash-table)
(deftype %ipynb-format.nbformat () 'integer)
(deftype %ipynb-format.nbformat-minor () 'integer)
(deftype %ipynb-format.cells () 'list)
(defstruct ipynb-format
  (metadata nil :type %ipynb-format.metadata)
  (nbformat 4 :type %ipynb-format.nbformat)
  (nbformat-minor 0 :type %ipynb-format.nbformat-minor)
  (cells nil :type %ipynb-format.cells))

(defmethod yason:encode ((object ipynb-format) &optional (stream *standard-output*))
  (yason:with-output (stream)
    (yason:with-object ()
      (yason:encode-object-element "metadata"
        (ipynb-format-metadata object))
      (yason:encode-object-element "nbformat"
        (ipynb-format-nbformat object))
      (yason:encode-object-element "nbformat_minor"
        (ipynb-format-nbformat-minor object))
      (yason:encode-object-element "cells"
        (ipynb-format-cells object)))))

(defun %make-ipynb-format.metadata ()
  (let ((ht (make-hash-table :test #'equal)))
    (setf (gethash "signature" ht) "hex-digest"
          (gethash "kernel_info" ht) (let ((ki (make-hash-table :test #'equal)))
                                       (setf (gethash "name" ki) "darkmatter")
                                       ki)
          (gethash "language_info" ht) (let ((li (make-hash-table :test #'equal)))
                                         (setf (gethash "name" li) "common-lisp"
                                               (gethash "version" li) "X3J13"
                                               (gethash "codemirror_mode" li) "commonlisp")
                                         li))
    ht))

(defun %make-ipynb-code-cell.metadata (collapsed autoscroll)
  (let ((ht (make-hash-table :test #'equal)))
    (setf (gethash "collapsed" ht)
          (if collapsed 'yason:true 'yason:false)
          (gethash "autoscroll" ht)
          (if autoscroll 'yason:true 'yason:false))
    ht))

(defun %make-ipynb-stream-output (output)
  (make-ipynb.stream-output
    :output-type "stream"
    :name (case (stream-output-stream output)
            (:stdout "stdout")
            (:stderr "stderr"))
    :text (stream-output-source output)))

(defun %make-ipynb-display-data (output)
  (make-ipynb.display-data
    :output-type "display_data"
    :data (plist-to-hash-table (display-data-output-data output))
    :metadata (plist-to-hash-table (display-data-output-metadata output))))

(defun %make-ipynb-execute-result (output)
  (make-ipynb.execute-result
    :output-type "execute_result"
    :execution-count (execute-result-output-execution-count output)
    :data (plist-to-hash-table (execute-result-output-data output))
    :metadata (plist-to-hash-table (execute-result-output-metadata output))))

(defun %make-ipynb-error-output (output)
  (make-ipynb.error-output
    :output-type "error"
    :ename (error-output-name output)
    :evalue (error-output-value output)
    :traceback (error-output-traceback output)))

(defun %map-to-ipynb-code-cell-output (output)
  (typecase output
    (stream-output-entity
      (%make-ipynb-stream-output output))
    (display-data-output-entity
      (%make-ipynb-display-data output))
    (execute-result-output-entity
      (%make-ipynb-execute-result output))
    (error-output-entity
      (%make-ipynb-error-output output))))

(defun %convert-to-ipynb-code-cell (cell)
  (make-ipynb.code-cell
    :cell-type "code"
    :metadata (%make-ipynb-code-cell.metadata
                (code-cell-collapsed cell)
                (code-cell-autoscroll cell))
    :source (code-cell-source cell)
    :execution-count (code-cell-execution-count cell)
    :outputs (mapcar #'%map-to-ipynb-code-cell-output (code-cell-outputs cell))))

(defun %convert-to-ipynb-markdown-cell (cell)
  (make-ipynb.markdown-cell
    :cell-type "markdown"
    :metadata (make-hash-table :test #'equal)
    :source (note-cell-source cell)))

(defun %make-ipynb-raw-cell.metadata-for-asciidoc ()
  (let ((ht (make-hash-table :test #'equal)))
    (setf (gethash "format" ht)
          "text/asciidoc")
    ht))

(defun %convert-to-ipynb-raw-cell-from-asciidoc (cell)
  (make-ipynb.raw-cell
    :cell-type "raw"
    :metadata (%make-ipynb-raw-cell.metadata-for-asciidoc)
    :source (note-cell-source cell)))

(defun %make-ipynb-raw-cell.metadata-for-latex ()
  (let ((ht (make-hash-table :test #'equal)))
    (setf (gethash "format" ht)
          "text/html")
    ht))

(defun %convert-to-ipynb-raw-cell-from-latex (cell)
  (make-ipynb.raw-cell
    :cell-type "raw"
    :metadata (%make-ipynb-raw-cell.metadata-for-latex)
    :source (note-cell-source cell)))

(defun %make-ipynb-raw-cell.metadata (format)
  (let ((ht (make-hash-table :test #'equal)))
    (setf (gethash "format" ht)
          format)
    ht))

(defun %convert-to-ipynb-raw-cell (cell)
  (make-ipynb.raw-cell
    :cell-type "raw"
    :metadata (%make-ipynb-raw-cell.metadata (raw-cell-format cell))
    :source (raw-cell-source cell)))

(defun %map-to-ipynb-cell (cell)
  (typecase cell
    (code-cell-entity
      (%convert-to-ipynb-code-cell cell))
    (note-cell-entity
      (case (note-cell-format cell)
        (:markdown
          (%convert-to-ipynb-markdown-cell cell))
        (:asciidoc
          (%convert-to-ipynb-raw-cell-from-asciidoc cell))
        (:latex
          (%convert-to-ipynb-raw-cell-from-latex cell))))
    (raw-cell-entity
      (%convert-to-ipynb-raw-cell cell))))

(defun map-to-ipynb (cells)
  (make-ipynb-format
    :metadata (%make-ipynb-format.metadata)
    :cells (mapcar #'%map-to-ipynb-cell cells)))

(defun serialize.ipynb (ipynb)
  (let ((stream (make-string-output-stream)))
    (yason:encode ipynb stream)
    (get-output-stream-string stream)))

(defun deserialize.ipynb ()
  )
