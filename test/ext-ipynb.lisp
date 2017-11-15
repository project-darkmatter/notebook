(in-package :cl-user)
(defpackage darkmatter/notebook/test/extentions/ipynb
  (:use :cl
        :darkmatter/notebook/extentions/ipynb
        :prove))
(in-package :darkmatter/notebook/test/extentions/ipynb)


(diag "Serialize/Deserialize .ipynb tests")

(plan 2)

(subtest "Serialize .ipynb"
  (let ((raw (make-ipynb
               :metadata '(:signature :hex-digest
                           :kernel-info (:name "darkmatter")
                           :language-info (:name "common-lisp"
                                           :version "X3J13"
                                           :codemirror-mode "commonlisp"))
               :nbformat 4
               :nbformat-minor 0
               :cells (list (make-cell :type "markdown"
                                       :metadata nil
                                       :source '("some *markdown*"))
                            (make-cell :type "code"
                                       :execution-count 1
                                       :metadata '(:collapsed t
                                                   :autoscroll nil)
                                       :source '("some code")
                                       :outputs `(,(make-code-cell-output
                                                     :type :stream
                                                     :name "stdout"
                                                     :text '("multiline stream text"))))))))
    (is (serialize.ipynb raw)
        "{\"metadata\":{\"signature\":\"hex-digest\",\"kernel_info\":{\"name\":\"darkmatter\"},\"language_info\":{\"name\":\"common-lisp\",\"version\":\"X3J13\",\"codemirror_mode\":\"commonlisp\"}},\"nbformat\":4,\"nbformat_minor\":0,\"cells\":[{\"cell_type\":\"markdown\",\"metadata\":{},\"source\":[\"some *markdown*\"]},{\"cell_type:\"code\",\"execution_count:1,\"metadata\":{\"collapsed\":True,\"autoscroll\":False},\"source\":[\"some code\"],\"outputs\":[{\"output_type\":\"stream\",\"name\":\"stdout\",\"text\":[\"multiline stream text\"]}]\"\"}]}")))

(subtest "Deserialize .ipynb"
  )
