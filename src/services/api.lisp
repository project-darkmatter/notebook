(in-package :cl-user)
(defpackage darkmatter/notebook/services/api
  (:use :cl)
  (:export :service.api))
(in-package :darkmatter/notebook/services/api)

(defparameter +server-ip+ "127.0.0.1") ;; TODO Configurable with command line arguments

(defparameter +launch-server+
  (if (= 0 (third (multiple-value-list (uiop:run-program "which darkmatter" :ignore-error-status t))))
      "darkmatter"
      (format nil "exec ~A"
              (asdf:system-relative-pathname "darkmatter-core" #P"roswell/darkmatter.ros"))))

(defstruct (server-port-client (:conc-name %))
  (server nil)
  (port nil :type integer)
  (client nil))

(defparameter *server-table*
  (make-hash-table :test #'equal))

(defun %parse-port-number (string)
  (let ((index (search "localhost:" string)))
    (if index
        (parse-integer string :start (+ index #.(length "localhost:")) :junk-allowed t))))

(defun %make-server-process (logfile &key (timeout 50))
  ;; TODO Check logfile exists
  ;; TODO Read port number from logfile
  (let* ((server (uiop:launch-program (format nil "~A --log=~A" +launch-server+ logfile)
                                      :output :stream))
         (port nil)
         (client (jsonrpc:make-client)))
    (loop for cnt from 0 below timeout
          until (numberp port) do
          (format t ".")
          (force-output)
          (sleep 1)
          (let ((line (read-line (uiop:process-info-output server))))
            (setf port (%parse-port-number line))))
    (fresh-line)
    (make-server-port-client :server server
                             :port port
                             :client (jsonrpc:client-connect client
                                                             :url (format nil "ws://~A:~A" +server-ip+ port)
                                                             :mode :websocket))))

(defun %read-raw-body (env)
  (let ((raw-body (flexi-streams:make-flexi-stream
                    (getf env :raw-body)
                    :external-format (flexi-streams:make-external-format :utf-8)))
        (result (make-array 0 :element-type 'character :fill-pointer 0 :adjustable t)))
    (with-output-to-string (out result)
      (loop for line = (read-line raw-body nil nil) while line
            do (write-line line out)))
    result))

(defstruct %request
  (id 0 :type integer)
  (method nil :type string)
  (params nil :type hash-table)
  (descripter nil :type string))

(defun %map-to-request (ht)
  (typecase ht
    (hash-table
      (let ((id (gethash "id" ht))
            (method (gethash "method" ht))
            (params (gethash "params" ht))
            (descripter (gethash "descripter" ht)))
        (if (notevery #'null (list id method params descripter))
            (make-%request :id id
                           :method method
                           :params params
                           :descripter descripter)
            nil)))
    (otherwise
      nil)))

(defun %encode-to-string (ht)
  (let ((stream (make-string-output-stream)))
    (yason:encode ht stream)
    (get-output-stream-string stream)))

(defun %response-result (id result)
  (format nil "{\"jsonrpc\": \"2.0\", \"id\": ~S, \"result\": ~A}" id result))

(defun service.api (env rest)
  (declare (ignore rest))
  (format t "[IN] SERVICE.API~%")
  (let* ((raw-body (%read-raw-body env))
         (request (%map-to-request
                    (handler-case (yason:parse raw-body)
                      (error (e) nil))))) ;; TODO Error handling - Invalid format
    (format t "~A~%" request)
    (format t "~A~%" (%encode-to-string (%request-params request)))
    (if request
        (let* ((descripter (%request-descripter request))
               (instance (gethash descripter *server-table*)))
          (when (null instance)
            (setf instance (%make-server-process descripter)
                  (gethash descripter *server-table*) instance))
          (let* ((client (%client instance))
                 (result (jsonrpc:call client (%request-method request) (%request-params request) :timeout 3.0))
                 (json (%encode-to-string result)))
            `(200 (:content-type "application/json")
              (,(%response-result (%request-id request) json)))))
        nil))) ;; TODO Error handling - Missing method or parameters

