;; on lisp
;; http://www.komaba.utmc.or.jp/~flatline/onlispjhtml/

(define-module liv.onlisp.macros
  (use liv.cl)
  (export-all))

(select-module liv.onlisp.macros)

(define-syntax nif
  (syntax-rules ()
    ((_ exp pos zero neg)
     (let1 val exp
         (case (truncate (cl:signum val))
           ((1) pos)
           ((0) zero)
           ((-1) neg))))))

(define-macro (with-gensyms syms . body)
  `(let ,(map (lambda (s)
                `(,s (gensym)))
              syms)
     ,@body))


(define-macro (aif pred then . else)
  `(let ((it ,pred))
     (if it ,then ,@else)))

(define-macro (awhen pred . body)
  `(aif ,pred
        (begin ,@body)))

(define-macro (awhile expr . body)
  `(do ((it ,expr ,expr))
       ((not it))
     ,@body))

(define-macro (aand . args)
  (cond ((null? args) #t)
        ((null? (cdr args))(car args))
        (else `(aif ,(car args)(aand ,@(cdr args))))))

(define-macro (alambda params . body)
  `(letrec ((self (lambda ,params ,@body)))
     self))

(provide "lib/onlisp/macros")