(define-module liv.binds
  (use liv.cl)
  (export labels label bind-vars let/ &))

(select-module liv.binds)

(define labels cl:labels)

(define-syntax label
  (syntax-rules ()
    ((_ (name (var ...) fbody ...) body ...)
     (letrec ((name (lambda (var ...)
                      fbody ...)))
       body ...))))

(define-syntax bind-vars
  (syntax-rules ()
    ((_ () body ...)
     (let ()
       body ...))
    ((_ ((var val) more ...) body ...)
     (let ((var val))
       (bind-vars (more ...)
                  body ...)))
    ((_ ((var) more ...) body ...)
     (bind-vars ((var #f))
                (bind-vars (more ...)
                           body ...)))
    ((_ (var more ...) body ...)
     (bind-vars ((var))
                (bind-vars (more ...)
                           body ...)))))

(define-syntax let/
  (syntax-rules ()
    ((_ val (var ...) body ...)
     (let ((v val))
       (let ((var v) ...)
         body ...)))))

;; (define-macro (& exp . body)
;;   `(let1 <> ,exp ,@body))

(define-syntax allf
  (syntax-rules ()
    ((_ val arg1 arg2 ...)
     (let ((v val))
       (set! arg1 v)
       (set! arg2 v)...))))

;; http://github.com/quek/quek/blob/master/base.lisp
(define-syntax call-with-ca/dr
  (syntax-rules ()
    ((_ ls proc)
     (proc (car ls)(cdr ls)))))

(provide "liv/binds")