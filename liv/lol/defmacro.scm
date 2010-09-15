(define-module liv.lol.defmacro
  (use srfi-1)
  (use srfi-13)
  (use liv.cl)
  (use liv.onlisp.utils)
  (use gauche.parameter)
  (export *g!-symbol* *o!-symbol* *defmacro!-symbol-position*
          defmacro defmacro/g! defmacro!))
(select-module liv.lol.defmacro)


(define *g!-symbol* (make-parameter 'g!))
(define *o!-symbol* (make-parameter 'o!))
(define *defmacro!-symbol-position* (make-parameter 'prefix))

(define (mark-position)
  (case (*defmacro!-symbol-position*)
    ((prefix) string-prefix?)
    ((sufix) string-prefix?)))

(define (mark-symbol? sym mark pred)
  (pred (symbol->string mark)(symbol->string sym)))

(define (g!-symbol? sym)
  (mark-symbol? sym (*g!-symbol*)(mark-position)))

(define (o!-symbol? sym)
  (mark-symbol? sym (*o!-symbol*)(mark-position)))

(define (remove-mark sym)
  (let ((symstr (symbol->string sym))
        (gs (symbol->string (*g!-symbol*)))
        (os (symbol->string (*o!-symbol*))))
    (case (*defmacro!-symbol-position*)
      ((prefix)(string-drop symstr (string-length os)))
      ((sufix)(string-drop-right symstr (string-length os))))))

(define (o!-symbol->g!-symbol sym)
  (let ((symstr (symbol->string sym))
        (gs (symbol->string (*g!-symbol*)))
        (os (symbol->string (*o!-symbol*))))
    (let1 rsym (remove-mark sym)
      (string->symbol
       (case (*defmacro!-symbol-position*)
         ((prefix)(string-append gs rsym))
         ((sufix)(string-append rsym gs)))))))

(define-macro (defmacro/g! name args . body)
  (let1 syms (cl:remove-duplicates (filter g!-symbol? (flatten body)))
    `(define-macro (,name ,@args)
       (let ,(map (lambda (s)
                    `(,s (gensym ,(remove-mark s)))) syms)
         ,@body))))

(define-macro (defmacro! name args . body)
  (let* ((os (filter o!-symbol? args))
         (gs (map o!-symbol->g!-symbol os)))
    `(defmacro/g! ,name ,args
       `(let ,(map list (list ,@gs)(list ,@os))
          ,(begin ,@body)))))

(define-syntax defmacro
  (syntax-rules ()
    ((_ name (arg ...) body ...)
     (define-macro (name arg ...) body ...))))

(provide "liv/lol/defmacro")