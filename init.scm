(define-module liv.init
  (export-all))
(select-module liv.init)

(use srfi-1)

(define (inc n)
  (+ n 1))

(define (dec n)
  (- n 1))

(define (square n)
  (* n n))

(define (triple n)
  (* n n n))

(define (identities . rest)
  rest)

(provide "liv/init")