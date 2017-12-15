#|
  This file is a part of Project Darkmatter.
  Copyright (c) 2017 Eddie (tamamu.1r1s@gmail.com)
|#

#|
  Author: Eddie (tamamu.1r1s@gmail.com)
|#

(in-package :cl-user)
(defpackage darkmatter-notebook-asd
  (:use :cl :asdf))
(in-package :darkmatter-notebook-asd)

(defsystem darkmatter-notebook
  :version "1.0.0"
  :author "Eddie"
  :license ""
  :depends-on (:clack            ;LLGPL
               :websocket-driver ;BSD-2-Clause
               :jsonrpc          ;BSD-2-Clause
               :yason            ;BSD-2-Clause
               :cl-fad           ;BSD-2-Clause
               :djula            ;MIT
               )
  :components ((:module "src"
                :components
                (
                (:file "main" :depends-on (;"config"
                                            "services"
                                            "utils"
                                            ))
                ; (:file "config")
                 (:module "utils"
                          :components ((:file "split")
                                       (:file "convert")
                                       (:file "string-case")
                                       (:file "file")))
                 (:module "domains"
                          :components ((:file "cell")))
                 (:file "extention" :depends-on ("extentions"
                                                 "utils"))
                 (:module "extentions"
                          :components ((:file "ext-ipynb")
                ;                       ;(:module "lisp"
                ;                       ;         :components ((:file "serialize")
                ;                       ;                      (:file "deserialize")))
                ;                       ;(:module "html"
                ;                       ;         :components ((:file "serialize")
                ;                       ;                      (:file "deserialize")))
                                       )
                          :depends-on ("utils"
                                       "domains"))
                 (:module "view"
                          :components ((:file "base")
                                       (:file "notebook" :depends-on ("base"))
                                       ;(:file "tree")
                                       ))
                 (:module "services"
                          :components ((:file "api")
                                       (:file "notebook")
                ;                       ;(:file "relative")
                ;                       ;(:file "absolute")
                ;                       ;(:file "store")
                                      )
                          :depends-on ("extention"
                                       "view"))
                )
                ))
  :description ""
  :long-description
  #.(with-open-file (stream (merge-pathnames
                             #p"README.md"
                             (or *load-pathname* *compile-file-pathname*))
                            :if-does-not-exist nil
                            :direction :input)
      (when stream
        (let ((seq (make-array (file-length stream)
                               :element-type 'character
                               :fill-pointer t)))
          (setf (fill-pointer seq) (read-sequence seq stream))
          seq)))
  :in-order-to ((test-op (test-op darkmatter-notebook-test))))
