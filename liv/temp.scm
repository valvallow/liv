;; my macros

(define-module liv.temp
  (export-all))

(select-module liv.temp)

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

;; (define-syntax downto
;;   (syntax-rules ()
;;     ((_ (var init end step) body ...)
;;      (do ((var init (- var step)))
;;          ((< var end))
;;        body ...))
;;     ((_ (var init end) body ...)
;;      (downto (var init end 1) body ...))))

;; (define-syntax upto
;;   (syntax-rules ()
;;     ((_ (var init end step) body ...)
;;      (do ((var init (+ var step)))
;;          ((> var end))
;;        body ...))
;;     ((_ (var init end) body ...)
;;      (upto (var init end 1) body ...))))


(provide "liv/temp")
