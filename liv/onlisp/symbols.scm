(define-module liv.onlisp.symbols
  (export-all))

(select-module liv.onlisp.symbols)

(define (mkstr . args)
  (with-output-to-string
    (lambda ()
      (dolist (a args)
        (display a)))))

(define (symb . args)
  (string->symbol (apply mkstr args)))

(define (explode sym)
  (map (compose string->symbol string)
       ((compose string->list symbol->string) sym)))

(provide "liv/onlisp/symbols")