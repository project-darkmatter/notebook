#|
  This file is a part of Project Darkmatter.
  Copyright (c) 2017 Eddie
|#

(in-package :cl-user)
(defpackage darkmatter-notebook-test-asd
  (:use :cl :asdf))
(in-package :darkmatter-notebook-test-asd)

(defsystem darkmatter-notebook-test
  :author "Eddie"
  :license ""
  :depends-on (:darkmatter-notebook
               :prove)
  :components ((:module "test"
                :components
                ((:module "utils"
                          :components
                          ((:test-file "convert")
                           (:test-file "file")))
                (:test-file "ext-ipynb")
                 ;(:test-file "view")
                 ;(:test-file "services")
                 )
                ))
  :description "Test system for darkmatter notebook"

  :defsystem-depends-on (:prove-asdf)
  :perform (test-op :after (op c)
                    (funcall (intern #.(string :run-test-system) :prove-asdf) c)
                    (asdf:clear-system c)))
