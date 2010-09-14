(define-module liv.lol.macros
  (export-all))

(select-module liv.lol.macros)

(define-syntax dlambda
  (syntax-rules (else)
    ((_ (msg1 (darg1 ...) dbody1 ...)(msg2 (darg2 ...) dbody2 ...) ...)
     (lambda (key . args)
       (case key
         ((msg1)(apply (lambda (darg1 ...)
                        dbody1 ...) args))
         ((msg2)(apply (lambda (darg2 ...)
                        dbody2 ...) args))
         ...
         (else key))))))

(provide "liv/lol/macros")