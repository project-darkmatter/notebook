(in-package :cl-user)
(defpackage darkmatter/notebook/view/base
  (:use :cl)
  (:export :*pages-store*
           :render-html))
(in-package :darkmatter/notebook/view/base)

(defvar *pages-store*
  (make-instance 'djula:file-store
                 :search-path
                 (list (asdf:system-relative-pathname "darkmatter-notebook"
                                                      "templates/"))))

(defun render-html (string)
  `(200 (:content-type "text/html")
    (,string)))
