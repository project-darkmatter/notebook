(in-package :cl-user)
(defpackage darkmatter/notebook/test/utils/file
  (:use :cl
        :darkmatter/notebook/utils/file
        :prove))
(in-package :darkmatter/notebook/test/utils/file)

(plan 1)

(defparameter *path*
  (asdf:system-relative-pathname "darkmatter-notebook" "test/test.txt"))

(is (string-trim '(#\Newline #\Space) (read-file-into-string *path*))
    "This is test file.")

(finalize)
