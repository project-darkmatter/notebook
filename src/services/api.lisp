(in-package :cl-user)
(defpackage darkmatter/notebook/services/notebook
  (:use :cl)
  (:export :service.api))
(in-package :darkmatter/notebook/services/notebook)

(defparameter +launch-server+
  (if (= 0 (third (multiple-value-list (uiop:run-program "which darkmatter" :ignore-error-status t))))
      "darkmatter"
      (format nil "exec ~A"
              (asdf:system-relative-pathname "darkmatter-core" #P"roswell/darkmatter.ros")))) 

(defstruct (server-port (:conc-name %))
  (server nil)
  (port nil :type integer))

(defun %parse-port-number (string)
  (dotimes (index (length string))
    (when (eq #\: (char string index))
      (return (parse-integer string :start (1+ index) :junk-allowed t)))))

(defun %make-server-process (sum &key (timeout 50))
  (let* ((server (uiop:launch-program (format nil "~A --log=~A" +launch-server+ sum)
                                      :output :stream))
         (port nil))
    (loop for cnt from 0 below timeout
          until (numberp port) do
          (format t ".")
          (force-output)
          (sleep 1)
          (setf port (%parse-port-number
                       (read-line
                         (uiop:process-info-output server)))))
    (fresh-line)
    (make-server-port :server server :port port)))

(defun service.api (env rest)
  (declare (ignore rest))
  )
