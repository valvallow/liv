(define-module liv.mac
  (export-all))

(select-module liv.mac)

(define-syntax mac
  (syntax-rules ()
    ((_ exp)
     (macroexpand 'exp))))

(define-syntax mac1
  (syntax-rules ()
    ((_ exp)
     (macroexpand-1 'exp))))

(provide "liv/mac")