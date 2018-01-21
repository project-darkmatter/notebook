(in-package :cl-user)
(defpackage darkmatter/notebook/test/utils/string-case
  (:use :cl
        :darkmatter/notebook/utils/string-case
        :prove))
(in-package :darkmatter/notebook/test/utils/string-case)

(plan 2)

(is (string-case "foo"
      ("bar" 1)
      ("baz" 2)
      (t 3))
    3)

(is-print (string-case "blah"
            ("common" (princ "lisp"))
            ("lisp" (princ "common"))
            ("blah" (princ "blah")))
          "blah")

(finalize)
