(define-module liv.matrix
  (use srfi-1) ; list-tabulate, drop
  (use srfi-9) ; define-record-type
  (use util.list) ; slices
  (use liv.lists) ; list-repeat
  (export-all))
(select-module liv.matrix)

(define (make-matrix w h :optional (seed-fun identity))
    (let1 size (* w h)
      (slices (list-tabulate size seed-fun) w)))

(define (map-matrix proc matrix)
  (map (pa$ map proc) matrix))

(define (matrix-ref matrix x y)
  (list-ref (list-ref matrix y) x))

(define (matrix-size matrix)
  (values (length matrix)(length (car matrix))))

(define (map-matrix-with-index proc matrix)
  (let ((x 0)(y 0))
    (map (lambda (row)
           (set! x 0)
           (rlet1 r (map (lambda (e)
                           (rlet1 r (proc e x y)
                                  (inc! x)))
                         row)
                  (inc! y)))
         matrix)))

(define (print-matrix matrix . keywords)
  (let-keywords* keywords ((printer print)
                           (row-mapper map)
                           (element-fun identity))
    (for-each (lambda (row)
                (printer (row-mapper element-fun row))) matrix)))

(define (matrix-row-ref matrix y)
  (list-ref matrix y))

(define (matrix-col-ref matrix x)
  (fold-right (lambda (row acc)
                (cons (car (drop row x))
                      acc)) '() matrix))

(provide "liv/matrix")