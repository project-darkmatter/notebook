(in-package :cl-user)
(defpackage darkmatter/notebook
  (:use :cl)
  (:import-from :lack.builder
                :builder)
  (:import-from :clack
                :clackup)
  (:import-from :darkmatter/notebook/utils/split
                :split-url)
  (:import-from :darkmatter/notebook/services/notebook
                :service.notebook)
  (:export :start
           :stop))
(in-package :darkmatter/notebook)

(defvar *root-directory*
  (asdf:system-relative-pathname "darkmatter-notebook" ""))

(defvar *handler* nil)

(defvar *router*
  (lambda (env)
    (let* ((url (split-url (getf env :request-uri)))
           (first (first url))
           (rest (rest url)))
      (if (null first)
          ;nil
          (service.notebook env "")
          (cond
            ((string= first "tree") nil)
            ((string= first "relative") nil)
            ((string= first "absolute") nil)
            ((string= first "api") nil)
            (t nil))))))

(defvar *web*
  (builder
    (:static :path (lambda (path) nil)
             :root *root-directory*)
    *router*))

(defun start (&rest args &key server port &allow-other-keys)
  (declare (ignore server port))
  (when *handler*
    (restart-case (error "Darkmatter Notebook is already running.")
      (restart-darkmatter-notebook ()
        :report "Restart Darkmatter Notebook"
        (stop))))
  (setf *handler*
        (apply #'clackup *web* args)))

(defun stop ()
  (prog1
    (clack:stop *handler*)
    (setf *handler* nil)))
