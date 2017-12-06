(in-package :cl-user)
(defpackage darkmatter/notebook/extention
  (:use :cl)
  (:import-from :darkmatter/notebook/utils/string-case
                :string-case)
  (:import-from :darkmatter/notebook/utils/file
                :read-file-into-string)
  (:import-from :darkmatter/notebook/extentions/ipynb
                :deserialize.ipynb
                :convert-to-cells-from-ipynb)
  (:export :read-as-notebook))
(in-package :darkmatter/notebook/extention)

(defun %read-as-ipynb (pathname)
  (let ((source (read-file-into-string pathname)))
    (convert-to-cells-from-ipynb
      (deserialize.ipynb source))))

(defun read-as-notebook (pathname)
  (let ((extention (string-upcase (pathname-type pathname))))
    (string-case extention
      ("IPYNB" (%read-as-ipynb pathname))
      (t nil))))
