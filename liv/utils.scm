(define-module liv.utils
  (use srfi-1)
  (use srfi-8)
  (export-all))

(select-module liv.utils)

(define (cars+cdrs ls . rest-lists)
  (let1 lists (cons ls rest-lists)
    (let loop ((lists lists))
      (if (null? lists)
          (values '() '())
          (receive (ls rest-lists)(car+cdr lists)
            (receive (a d)(car+cdr ls)
              (receive (cars cdrs)(loop rest-lists)
                (values (cons a cars)(cons d cdrs)))))))))

(define (compress ls . opt)
  (let-optionals* opt ((ep? equal?))
    (pair-fold
     (lambda (pr acc)
       (let/cc hop
         (append acc
                 (if (null? (cdr pr))
                     pr
                     (if (ep? (car pr)(cadr pr))
                         (hop acc)
                         (list (car pr)))))))
     '() ls)))

(define (my-but-last ls)
  (let ((kddr (cddr ls)))
    (if (null? kddr)
        ls
        (my-but-last kddr))))

(define (range min max)
  (iota (+ (- max min) 1) min))

(define (list-repeat n obj)
  (list-tabulate n (lambda args obj)))

(provide "liv/utils")