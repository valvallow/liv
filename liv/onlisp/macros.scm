;; on lisp
;; http://www.komaba.utmc.or.jp/~flatline/onlispjhtml/

(define-module liv.onlisp.macros
  (export-all))

(select-module liv.onlisp.macros)



(define-macro (with-gensyms syms . body)
  `(let ,(map (lambda (s)
                `(,s (gensym)))
              syms)
     ,@body))

(provide "lib.onlisp.macros")