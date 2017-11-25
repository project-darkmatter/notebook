(in-package :cl-user)
(defpackage darkmatter/notebook/extentions/ipynb
  (:use :cl)
  (:export :serialize.ipynb
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

(defstruct (ipynb.raw-cell (:include ipynb.cell)))

(defmethod yason:encode ((object ipynb.raw-cell) &optional (stream *standard-output*))
  (yason:with-output (stream)
    (yason:with-object ()
      (yason:encode-object-element "cell_type"
        (ipynb.cell-cell-type object))
      (yason:encode-object-element "metadata"
        (ipynb.cell-metadata object))
      (yason:encode-object-element "source"
        (ipynb.cell-source object)))))

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

(defun serialize.ipynb ()
  )

(defun deserialize.ipynb ()
  )
