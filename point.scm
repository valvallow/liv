(define-module liv.point
  (use srfi-9)
  (export-all))
(select-module  liv.point)

(define-record-type point
  (make-point x y) point?
  (x point-x)
  (y point-y))

(define (negative-point? p)
  (any negative? (list (point-x p)(point-y p))))

(define (add-point p1 p2)
  (make-point (+ (point-x p1)
                 (point-x p2))
              (+ (point-y p1)
                 (point-y p2))))

(provide "liv/point")