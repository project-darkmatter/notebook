(in-package :cl-user)
(defpackage darkmatter/notebook/utils/convert
  (:use :cl)
  (:export :plist-to-hash-table
           :hash-table-to-plist))
(in-package :darkmatter/notebook/utils/convert)

(defun plist-to-hash-table (plist)
  (let ((ht (make-hash-table :test #'equal)))
    (loop for (key value) on plist by #'cddr do
          (setf (gethash key ht) value))
    ht))

(defun hash-table-to-plist (ht)
  (let ((plist (list)))
    (maphash
      (lambda (key val)
        (setf plist (append plist (list key val))))
      ht)
    plist))
