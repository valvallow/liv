;; Common Lisp

(define-module liv.cl
  (use srfi-1)
  (export-all))

(select-module liv.cl)

(define (cl:signum x)
  (if (zero? x)
      x
      (/ x (abs x))))

(define cl:remove-if-not filter)

(define cl:remove-if remove)

(define (cl:remove-duplicates ls . eq?)
  (let-optionals* eq? ((eq? equal?))
    (pair-fold
     (lambda (pr acc)
       (if (find (pa$ eq? (car pr))(cdr pr))
           acc
           (append acc (list (car pr)))))
     '() ls)))

(define-syntax cl:labels
  (syntax-rules ()
    ((_ ((name (var ...) proc-body ...) ...) body ...)
     (letrec
         ((name (lambda (var ...)
                  proc-body ...))
          ...)
       body ...))))

(provide "liv/cl")