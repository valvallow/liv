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

;; (define-syntax if-true
;;   (syntax-rules ()
;;     ((_ pred exp)
;;      (if pred exp #f))))

;; (define-syntax let-opt1
;;   (syntax-rules ()
;;     ((_ args name val body ...)
;;      (let-optionals* args ((name val))
;;                     body ...))))

;; (define-syntax ext-let
;;   (syntax-rules ()
;;     ((_ "sub" ((var1 val1) ...)(var2 var3 ...)(val2 val3 ...) body ...)
;;      (ext-let "sub" ((var1 val1) ... (var2 val2))(var3 ...)(val3 ...) body ...))
;;     ((_ "sub" ((var val) ...)()() body ...)
;;      (let ((var val) ...)
;;        body ...))
;;     ((_ ()() body ...)
;;      (ext-let "sub" ()()() body ...))
;;     ((_ (var1 var2 ...)(val1 val2 ...) body ...)
;;      (ext-let "sub" ((var1 val1))(var2 ...)(val2 ...) body ...))))

(define-syntax across
  (syntax-rules ()
    ((_ exp) exp)
    ((_ exp1 exp2)
     (exp2 exp1))
    ((_ exp1 exp2 exp3 ...)
     (let1 val (across exp1 exp2)
       (across val exp3 ...)))
    ))

(define-syntax across-right
  (syntax-rules ()
    ((_ exp) exp)
    ((_ exp1 exp2)
     (exp1 exp2))
    ((_ exp1 exp2 exp3 ...)
     (exp1 (across-right exp2 exp3 ...)))))

(define-syntax for
  (syntax-rules ()
    ((_ ((var init) stop-exp upd-exp) body ...)
     (do ((var init upd-exp))
         ((not stop-exp))
       body ...))))

;; (define-syntax downto
;;   (syntax-rules ()
;;     ((_ (var init end step) body ...)
;;      (do ((var init (- var step)))
;;          ((< var end))
;;        body ...))
;;     ((_ (var init end) body ...)
;;      (downto (var init end 1) body ...))))
(define-syntax downto
  (syntax-rules ()
    ((_ (var init end step) body ...)
     (for ((var init)(<= end var)(- var step)) body ...))
    ((_ (var init end) body ...)
     (downto (var init end 1) body ...))))

;; (define-syntax upto
;;   (syntax-rules ()
;;     ((_ (var init end step) body ...)
;;      (do ((var init (+ var step)))
;;          ((> var end))
;;        body ...))
;;     ((_ (var init end) body ...)
;;      (upto (var init end 1) body ...))))
(define-syntax upto
  (syntax-rules ()
    ((_ (var init end step) body ...)
     (for ((var init)(<= var end)(+ var step)) body ...))
    ((_ (var init end) body ...)
     (upto (var init end 1) body ...))))

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

(define-syntax allf
  (syntax-rules ()
    ((_ val arg1 arg2 ...)
     (let ((v val))
       (set! arg1 v)
       (set! arg2 v)...))))

;; (define-syntax define-syntax-rule
;;   (syntax-rules ()
;;     ((_ (name (literal ...) arg ...)(body ...))
;;      (define-syntax name
;;        (syntax-rules (literal ...)
;;          ((_ arg ...)
;;           (body ...)))))
;;     ((_ (name arg ...)(body ...))
;;      (define-syntax-rule (name () arg ...)(body ...)))))

;; (define-syntax try
;;   (syntax-rules ()
;;     ((_ var a . b)
;;      (let/cc success
;;        (let/cc var
;;          (success a)) . b))))

;; (define-syntax implecations
;;   (syntax-rules (=>)
;;     ((_ (pred => body ...) ...)
;;      (begin
;;        (when pred
;;          body ...)
;;        ...))))

(define-macro (& exp . body)
  `(let1 <> ,exp ,@body))

(define-syntax mac
  (syntax-rules ()
    ((_ exp)
     (macroexpand 'exp))))

(define-syntax mac1
  (syntax-rules ()
    ((_ exp)
     (macroexpand-1 'exp))))

(provide "liv/macros")
