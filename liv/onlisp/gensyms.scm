;; on lisp
;; http://www.komaba.utmc.or.jp/~flatline/onlispjhtml/

(define-module liv.onlisp.gensyms
  (use liv.cl)
  (export-all))

(select-module liv.onlisp.gensyms)

;; (define-syntax nif
;;   (syntax-rules ()
;;     ((_ exp pos zero neg)
;;      (let1 val exp
;;          (case (truncate (cl:signum val))
;;            ((1) pos)
;;            ((0) zero)
;;            ((-1) neg))))))

(define-macro (with-gensyms syms . body)
  `(let ,(map (lambda (s)
                `(,s (gensym)))
              syms)
     ,@body))

(provide "lib/onlisp/gensyms")