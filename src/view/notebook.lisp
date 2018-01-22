(in-package :cl-user)
(defpackage darkmatter/notebook/view/notebook
  (:use :cl
        :darkmatter/notebook/view/base)
  (:export :view.notebook))
(in-package :darkmatter/notebook/view/notebook)

(let* ((djula:*current-store* *pages-store*)
       (template (djula:compile-template* "notebook.html")))
  (defun view.notebook (notebook descripter)
    (render-html
      (djula:render-template* template nil
                              :notebook notebook
                              :descripter descripter))))
