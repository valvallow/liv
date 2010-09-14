;; my macros

(define-module liv.macros
  (export-all))

(select-module liv.macros)


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

(define-syntax let-opt1
  (syntax-rules ()
    ((_ args name val body ...)
     (let-optionals* args ((name val))
                    body ...))))


(provide "liv/macros")
