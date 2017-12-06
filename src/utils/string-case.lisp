(in-package :cl-user)
(defpackage darkmatter/notebook/utils/string-case
  (:use :cl)
  (:export :string-case))
(in-package :darkmatter/notebook/utils/string-case)

(defmacro string-case (object &body body)
  (reduce
    (lambda (outer inner)
      (let ((predictor (first outer)))
        (if (eq predictor 't)
            `(progn ,@(rest outer))
            `(if (string= ,object ,predictor) (progn ,@(rest outer)) ,inner))))
    body
    :from-end t
    :initial-value nil))

