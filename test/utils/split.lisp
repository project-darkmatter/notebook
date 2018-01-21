(in-package :cl-user)
(defpackage darkmatter/notebook/test/utils/split
  (:use :cl
        :darkmatter/notebook/utils/split
        :prove))
(in-package :darkmatter/notebook/test/utils/split)

(plan 2)

(is (split "a,bb,ccc" #\,) #("a" "bb" "ccc") :test #'equalp)

(is (split-url "/foo/bar/baz") '("foo" "bar" "baz"))

(finalize)
