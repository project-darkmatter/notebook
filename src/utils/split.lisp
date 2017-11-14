(in-package :cl-user)
(defpackage darkmatter/notebook/utils/split
  (:use :cl)
  (:export :split
           :split-url))
(in-package :darkmatter/notebook/utils/split)

(defun split (str delim)
  (let ((res (make-array 0 :element-type 'string
                           :fill-pointer 0
                           :adjustable t)))
    (loop for i from 0 below (length str)
          with start = 0
          when (eq (char str i) delim)
          do (vector-push-extend (subseq str start i) res)
             (setf start (1+ i))
          finally (let ((tail (subseq str start)))
                    (when tail
                      (vector-push-extend tail res))))
  res))

(defun split-url (string)
  (if (eq #\/ (char string 0))
      (let ((splited (concatenate 'list (split (subseq string 1) #\/))))
        (if (string= "" (first splited))
            nil
            splited))
      (error "Not a url.")))
