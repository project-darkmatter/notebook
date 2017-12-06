(in-package :cl-user)
(defpackage darkmatter/notebook/utils/file
  (:use :cl)
  (:export :read-file-into-string))
(in-package :darkmatter/notebook/utils/file)

(defun read-file-into-string (pathname)
  (with-open-file (in pathname :direction :input)
    (let ((buf (make-string (file-length in))))
      (read-sequence buf s)
      buf)))
