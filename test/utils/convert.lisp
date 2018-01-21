(in-package :cl-user)
(defpackage darkmatter/notebook/test/utils/convert
  (:use :cl
        :darkmatter/notebook/utils/convert
        :prove))
(in-package darkmatter/notebook/test/utils/convert)

(plan 3)

(defvar *pl* '("foo" 42 "bar" "baz"))

(let* ((ht (plist-to-hash-table *pl*))
       (pl (hash-table-to-plist ht)))
  (is-values (gethash "foo" ht) '(42 T))
  (is-values (gethash "bar" ht) '("baz" T))
  (is pl *pl*))

(finalize)
