(define-module liv.across
  (export-all))
(select-module liv.across)

(define-syntax across
  (syntax-rules ()
    ((_ exp) exp)
    ((_ exp1 exp2)
     (exp2 exp1))
    ((_ exp1 exp2 exp3 ...)
     (let1 val (across exp1 exp2)
       (across val exp3 ...)))))

(define-syntax across-right
  (syntax-rules ()
    ((_ exp) exp)
    ((_ exp1 exp2)
     (exp1 exp2))
    ((_ exp1 exp2 exp3 ...)
     (exp1 (across-right exp2 exp3 ...)))))

(define >> across)
(define << across-right)

(provide "liv/across")