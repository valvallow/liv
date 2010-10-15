(define-module liv.matrix
  (use srfi-1) ; list-tabulate, drop
  (use srfi-9) ; define-record-type
  (use util.list) ; slices
  (use liv.list) ; list-repeat
  (export-all))
(select-module liv.matrix)

(define (make-matrix w h :optional (seed-fun identity))
    (let1 size (* w h)
      (slices (list-tabulate size seed-fun) w)))

(define (matrix-ref matrix x y)
  (list-ref (list-ref matrix y) x))

(define (matrix-set! matrix x y val)
  (let1 row (list-ref matrix y)
    (let1 rest (drop row x)
      (set-car! rest val)
      matrix)))

(define (matrix-copy matrix)
  (fold-right (lambda (row acc)
                (cons (list-copy row) acc))
              '() matrix))

(define (matrix-size matrix)
  (values (length matrix)(length (car matrix))))

(define (walk-matrix walker proc matrix)
  (walker (pa$ walker proc) matrix))

(define (map-matrix proc matrix)
  (walk-matrix map proc matrix))

(define (for-each-matrix proc matrix)
  (walk-matrix for-each proc matrix))

(define (walk-matrix-with-matrix walker proc matrix)
  (let ((x 0)(y 0))
    (walker (lambda (row)
              (set! x 0)
              (rlet1 r (walker (lambda (e)
                                 (rlet1 r (proc e x y)
                                        (inc! x)))
                               row)
                     (inc! y)))
            matrix)))

(define (map-matrix-with-index proc matrix)
  (walk-matrix-with-matrix map proc matrix))

(define (for-each-matrix-with-index proc matrix)
  (walk-matrix-with-matrix for-each proc matrix))

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