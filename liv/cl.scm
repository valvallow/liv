;; Common Lisp

(define-module liv.cl
  (use srfi-1)
  (export-all))

(select-module liv.cl)

(define cl:remove-if-not filter)

(define cl:remove-if remove)

(define-syntax cl:labels
  (syntax-rules ()
    ((_ ((name (var ...) proc-body ...) ...) body ...)
     (letrec
         ((name (lambda (var ...)
                  proc-body ...))
          ...)
       body ...))))

(provide "liv.cl")