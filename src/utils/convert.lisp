(in-package :cl-user)
(defpackage darkmatter/notebook/utils/convert
  (:use :cl)
  (:export :plist-to-hash-table))
(in-package :darkmatter/notebook/utils/convert)

(defun plist-to-hash-table (plist)
  (let ((ht (make-hash-table :test #'equal)))
    (loop for (key value) on plist by #'cddr do
          (setf (gethash key ht) value))
    ht))
