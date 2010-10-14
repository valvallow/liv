(define-module liv.predicate
  (export-all))
(select-module liv.predicate)

(define-syntax coalesce
  (syntax-rules ()
    ((_) #f)
    ((_ (exp val) x ...)
     (if exp
         val
         (coalesce x ...)))))

(define-syntax if-true
  (syntax-rules ()
    ((_ pred exp)
     (if pred exp #f))))


(provide "liv/predicate")