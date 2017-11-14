(in-package :cl-user)
(defpackage darkmatter/notebook/services/notebook
  (:use :cl)
  (:import-from :darkmatter/notebook/extention
                :read-as-notebook)
  (:import-from :darkmatter/notebook/view/notebook
                :view.notebook)
  (:export :service.notebook))
(in-package :darkmatter/notebook/services/notebook)

(defun service.notebook (env pathname)
  (let ((notebook (read-as-notebook pathname)))
    (view.notebook notebook)))
