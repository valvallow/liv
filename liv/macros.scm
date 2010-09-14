;; my macros

(define-module liv.macros
  (export-all))

(select-module liv.macros)

(define-syntax let-opt1
  (syntax-rules ()
    ((_ args name val body ...)
     (let-optionals* args ((name val))
                    body ...))))


(provide "liv.macros")
