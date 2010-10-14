(define-module liv.matrix
  (use srfi-1) ; list-tabulate
  (use srfi-9) ; define-record-type
  (use util.list) ; slices
  (use liv.lists) ; list-repeat
  (export-all))
(select-module liv.matrix)

(define-constant relatives
  `((-1 1)(0 1)(1 1)
    (-1 0)(1 0)
    (-1 -1)(0 -1)(1 -1)))

(define (make-matrix w h :optional (seed-fun identity))
    (let1 size (* w h)
      (slices (list-tabulate size seed-fun) w)))

(define (map-matrix proc matrix)
  (map (pa$ map proc) matrix))

(define (ref-matrix matrix x y)
  (list-ref (list-ref matrix y) x))

(define (matrix-size matrix)
  (values (length matrix)(length (car matrix))))

(define-record-type point
  (make-point x y) point?
  (x point-x)
  (y point-y))

(define-record-type cell
  (make-cell p value) cell?
  (p cell-point)
  (value cell-value))

(define (ref-matrix-with-point matrix p)
  (ref-matrix matrix (point-x p)(point-y p)))

(define (map-matrix-with-point proc matrix)
  (let ((x 0)(y 0))
    (map (lambda (row)
           (set! x 0)
           (rlet1 r (map (lambda (e)
                           (rlet1 r (proc e (make-point x y))
                                  (inc! x)))
                         row)
                  (inc! y)))
         matrix)))

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

(define (map-matrix-with-point proc matrix)
  (map-matrix-with-index (lambda (e x y)
                           (proc e (make-point x y))) matrix))

(define (negative-point? p)
  (any negative? (list (point-x p)(point-y p))))

(define (add-point p1 p2)
  (make-point (+ (point-x p1)
                 (point-x p2))
              (+ (point-y p1)
                 (point-y p2))))

(define (print-matrix matrix . keywords)
  (let-keywords* keywords ((printer print)
                           (row-mapper map)
                           (element-fun identity))
    (for-each (lambda (row)
                (printer (row-mapper element-fun row))) matrix)))

(provide "liv/matrix")