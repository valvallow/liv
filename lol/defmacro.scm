(define-module liv.lol.defmacro
  (use srfi-1)
  (use srfi-13)
  (use liv.cl)
  (use liv.onlisp.list)
  (use liv.list)
  (use gauche.parameter)
  (export *g!-symbol* *o!-symbol* *defmacro!-symbol-position*
          apply-defmacro!-config! defmacro defmacro/g! defmacro!))
(select-module liv.lol.defmacro)


(define *g!-symbol* (make-parameter 'g!))
(define *o!-symbol* (make-parameter 'o!))
(define *defmacro!-symbol-position* (make-parameter 'prefix))

(define %string-append string-append)
(define %mark-position string-prefix?)
(define %string-drop string-drop)

(define apply-defmacro!-config!
  (case-lambda
    ((g! o! pos)
     (*g!-symbol* g!)
     (*o!-symbol* o!)
     (*defmacro!-symbol-position* pos)
     (apply-defmacro!-config!))
    (()
     (case (*defmacro!-symbol-position*)
       ((prefix)
        (set! %string-append string-append)
        (set! %mark-position string-prefix?)
        (set! %string-drop string-drop))
       ((sufix)
        (set! %string-append (lambda (s1 s2)
                               (string-append s2 s1)))
        (set! %mark-position string-suffix?)
        (set! %string-drop string-drop-right))))))

(define (mark-symbol? sym mark pred)
  (pred (symbol->string mark)(symbol->string sym)))

(define (g!-symbol? sym)
  (mark-symbol? sym (*g!-symbol*) %mark-position))

(define (o!-symbol? sym)
  (mark-symbol? sym (*o!-symbol*) %mark-position))

(define (remove-mark sym)
  (%string-drop (symbol->string sym)
                (string-length (symbol->string (*o!-symbol*)))))

(define (o!-symbol->g!-symbol sym)
  (string->symbol
   (%string-append (symbol->string (*g!-symbol*))
                   (remove-mark sym))))

(define defmacro define-macro)

(defmacro (defmacro/g! name . body)
  (let1 syms (cl:remove-duplicates (filter g!-symbol? (flatten body)))
    `(defmacro (,(car name) ,@(cdr name))
       (let ,(map (lambda (s)
                    `(,s (gensym ,(remove-mark s)))) syms)
         ,@body))))

(defmacro (defmacro! name . body)
  (let* ((args (cdr name))
         (os (filter o!-symbol? (if (dotted-list? args)
                                    (dotted-list->list args)
                                    args)))
         (gs (map o!-symbol->g!-symbol os)))
    `(defmacro/g! (,(car name) ,@args)
       `(let ,(map list (list ,@gs)(list ,@os))
          ,(begin ,@body)))))

(provide "liv/lol/defmacro")