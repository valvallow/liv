(define-module liv.loops
  (export-all))
(select-module liv.loops)

(define-syntax for
  (syntax-rules ()
    ((_ ((var init) stop-exp upd-exp) body ...)
     (do ((var init upd-exp))
         ((not stop-exp))
       body ...))))

(define-syntax downto
  (syntax-rules ()
    ((_ (var init end step) body ...)
     (for ((var init)(<= end var)(- var step)) body ...))
    ((_ (var init end) body ...)
     (downto (var init end 1) body ...))))

(define-syntax upto
  (syntax-rules ()
    ((_ (var init end step) body ...)
     (for ((var init)(<= var end)(+ var step)) body ...))
    ((_ (var init end) body ...)
     (upto (var init end 1) body ...))))

(provide "liv/loops")