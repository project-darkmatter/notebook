(in-package :cl-user)
(defpackage darkmatter/notebook/extentions/ipynb
  (:use :cl)
  (:export :serialize.ipynb
           :deserialize.ipynb))
(in-package :darkmatter/notebook/extentions/ipynb)

(deftype %ipynb.cell-type () 'string)
(deftype %ipynb.cell-metadata () 'hash-table)
(deftype %ipynb.cell-source () '(or string list))
(defstruct ipynb.cell
  (cell-type "" :type %ipynb.cell-type)
  (metadata nil :type %ipynb.cell-metadata)
  (source nil :type %ipynb.cell-source))

(deftype %ipynb.code-cell-execution-count () '(or integer nil))
(deftype %ipynb.code-cell-outputs () 'list)
(defstruct (ipynb.code-cell (:include ipynb.cell))
  (execution-count 0 :type %ipynb.code-cell-execution-count)
  (outputs nil :type %ipynb.code-cell-outputs))

(defstruct (ipynb.raw-cell (:include ipynb.cell)))

(deftype %ipynb.code-cell-output-type () 'string)
(defstruct ipynb.code-cell-output
  (output-type "" :type %ipynb.code-cell-output-type))

(deftype %ipynb.stream-output-name () 'string)
(deftype %ipynb.stream-output-text () 'list)
(defstruct (ipynb.stream-output (:include ipynb.code-cell-output))
  (name "" :type %ipynb.stream-output-name)
  (text nil :type %ipynb.stream-output-text))

(deftype %ipynb.display-data-data () 'hash-table)
(deftype %ipynb.display-data-metadata () 'hash-table)
(defstruct (ipynb.display-data (:include ipynb.code-cell-output))
  (data nil :type %ipynb.display-data-data)
  (metadata nil :type %ipynb.display-data-metadata))

(deftype %ipynb.execute-result-execution-count () 'integer)
(deftype %ipynb.execute-result-data () 'hash-table)
(deftype %ipynb.execute-result-metadata () 'hash-table)
(defstruct (ipynb.execute-result (:include ipynb.code-cell-output))
  (execution-count 0 :type %ipynb.execute-result-execution-count)
  (data nil :type %ipynb.execute-result-data)
  (metadata nil :type %ipynb.execute-result-metadata))

(deftype %ipynb.error-output-ename () 'string)
(deftype %ipynb.error-output-evalue () 'string)
(deftype %ipynb.error-output-traceback () 'list)
(defstruct (ipynb.error-output (:include ipynb.code-cell-output))
  (ename 0 :type %ipynb.error-output-ename)
  (evalue nil :type %ipynb.error-output-evalue)
  (traceback nil :type %ipynb.error-output-traceback))



(defun serialize.ipynb ()
  )

(defun deserialize.ipynb ()
  )
