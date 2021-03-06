(in-package :cl-user)
(defpackage darkmatter/notebook/test/extentions/ipynb
  (:use :cl
        :darkmatter/notebook/extentions/ipynb
        :prove)
  (:import-from :darkmatter/notebook/domains/cell
                :note-cell-entity
                :code-cell-entity
                :stream-output-entity))
(in-package :darkmatter/notebook/test/extentions/ipynb)


(diag "Serialize/Deserialize .ipynb tests")

(plan 3)

(defvar *cells*
  (list
    (make-instance 'note-cell-entity
      :format :markdown
      :source (list "some *markdown*"))
    (make-instance 'code-cell-entity
      :source "some code"
      :execution-count 1
      :collapsed t
      :autoscroll nil
      :outputs (list
                 (make-instance 'stream-output-entity
                   :stream :stdout
                   :source (list "multiline stream text"))))))

(defvar *ipynb* nil)
(defvar *serialized* nil)

(subtest "Serialize .ipynb"
  (setf *ipynb* (map-to-ipynb *cells*)
        *serialized* (serialize.ipynb *ipynb*))
  (is *serialized*
      "{\"metadata\":{\"signature\":\"hex-digest\",\"kernel_info\":{\"name\":\"darkmatter\"},\"language_info\":{\"name\":\"common-lisp\",\"version\":\"X3J13\",\"codemirror_mode\":\"commonlisp\"}},\"nbformat\":4,\"nbformat_minor\":0,\"cells\":[{\"cell_type\":\"markdown\",\"metadata\":{},\"source\":[\"some *markdown*\"]},{\"cell_type\":\"code\",\"execution_count\":1,\"metadata\":{\"collapsed\":true,\"autoscroll\":false},\"source\":\"some code\",\"outputs\":[{\"output_type\":\"stream\",\"name\":\"stdout\",\"text\":[\"multiline stream text\"]}]}]}"))

(subtest "Deserialize .ipynb"
  (let* ((ipynb (deserialize.ipynb *serialized*))
         (serialized (serialize.ipynb ipynb)))
    (is serialized *serialized*)))

(subtest "Convert ipynb format structure to domain cell objects"
  (let* ((cells (convert-to-cells-from-ipynb *ipynb*)))
    (is-print (princ cells) (write-to-string *cells*))))

(finalize)
