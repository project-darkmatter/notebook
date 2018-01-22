(in-package :cl-user)
(defpackage darkmatter/notebook/services/notebook
  (:use :cl)
  (:import-from :flexi-streams
                :string-to-octets)
  (:import-from :ironclad
                :byte-array-to-hex-string
                :digest-sequence)
  (:import-from :darkmatter/notebook/extention
                :read-as-notebook)
  (:import-from :darkmatter/notebook/view/notebook
                :view.notebook)
  (:export :service.notebook))
(in-package :darkmatter/notebook/services/notebook)

(defparameter *tmpdir*
  #+windows (merge-pathnames
              (merge-pathnames
                (merge-pathnames
                  (user-homedir-pathname)
                  "AppData")
                "Local")
              "Temp")
  #-windows "/tmp")

(defun make-descripter (pathname)
  (byte-array-to-hex-string
    (digest-sequence
      :md5
      (string-to-octets pathname :external-format :utf-8))))

(defun service.notebook (env pathname)
  (let ((notebook (read-as-notebook pathname))
        (descripter (make-descripter pathname)))
    (print env)
    (print notebook)
    (view.notebook notebook (format nil "~A/darkmatter-notebook-~A" *tmpdir* descripter))))
