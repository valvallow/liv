;; PAIP chapter.6 tree-search
(define-module
  (use srfi-1)
  (use gauche.sequence)
  (use liv.paip.debugs)
  (export tree-search binary-tree finite-binary-tree diff sorter
          price-is-right is depth-first-search breadth-first-search
          best-first-search beam-search))
(select-module liv.paip.search)

;; (debug :search)
;; (undebug :search)

(define fail '())

;; (define (tree-search states goal? successors combiner)
;; ;;  (debug-indent :search 10 ";; Search: ~a" states)
;;   (dbg :search ";; Search: ~a" states)
;;   (cond ((null? states) fail)
;;         ((goal? (car states))(car states))
;;         (else (tree-search (combiner (successors (car states))
;;                                      (cdr states))
;;                            goal? successors combiner))))

;; (define (tree-search states goal? successors combiner)
;;   (if (null? states)
;;       fail
;;       (let1 a (car states)
;;         (if (goal? a)
;;             a
;;             (tree-search (combiner (successors a)
;;                                    (cdr states))
;;                          goal? successors combiner)))))

(define (tree-search states goal? successors combiner)
  (if (null? states)
      fail
      (let rec ((states states))
        (dbg :search ";; Search: ~a" states)
        (let1 a (car states)
          (if (goal? a)
              a
              (rec (combiner (successors a)
                             (cdr states))))))))

;; successors
(define (binary-tree x)
  (let1 x (* 2 x)
    (list x (+ 1 x))))

(define (finite-binary-tree n)
  (lambda (x)
    (remove (pa$ < n)
            (binary-tree x))))

;; cost function
(define (diff num)
  (compose abs (cut - <> num)))

(define (sorter cost-fn)
  (lambda (new old)
    (sort-by (append new old) cost-fn <)))

(define (price-is-right price)
  (lambda (x)
    (if (> x price)
        (greatest-fixnum)
        (- price x))))

;; goal?
(define (is value)
  (pa$ equal? value))

;; combiner
(define (prepend x y)
  (append y x))


;; search
(define (depth-first-search start goal? successors)
  (tree-search (list start) goal? successors append))

(define (breadth-first-search start goal? successors)
  (tree-search (list start) goal? successors prepend))

(define (best-first-search start goal? successors const-fn)
  (tree-search (list start) goal? successors (sorter const-fn)))

(define (beam-search start goal? successors cost-fn beam-width)
  (tree-search (list start) goal? successors
               (lambda (old new)
                 (let1 sorted ((sorter cost-fn) old new)
                   (if (> beam-width (length sorted))
                          sorted
                          (subseq sorted 0 beam-width))))))


;; (depth-first-search 1 (is 12) binary-tree)
;; endless loop ...

;; (depth-first-search 1 (is 12)(finite-binary-tree 15))
;; Search: (1)
;; Search: (2 3)
;; Search: (4 5 3)
;; Search: (8 9 5 3)
;; Search: (9 5 3)
;; Search: (5 3)
;; Search: (10 11 3)
;; Search: (11 3)
;; Search: (3)
;; Search: (6 7)
;; Search: (12 13 7)12

;; (breadth-first-search 1 (is 12) binary-tree)
;; Search: (1)
;; Search: (2 3)
;; Search: (3 4 5)
;; Search: (4 5 6 7)
;; Search: (5 6 7 8 9)
;; Search: (6 7 8 9 10 11)
;; Search: (7 8 9 10 11 12 13)
;; Search: (8 9 10 11 12 13 14 15)
;; Search: (9 10 11 12 13 14 15 16 17)
;; Search: (10 11 12 13 14 15 16 17 18 19)
;; Search: (11 12 13 14 15 16 17 18 19 20 21)
;; Search: (12 13 14 15 16 17 18 19 20 21 22 23)12

;; (best-first-search 1 (is 12) binary-tree (diff 12))
;; Search: (1)
;; Search: (3 2)
;; Search: (7 6 2)
;; Search: (14 15 6 2)
;; Search: (15 6 2 28 29)
;; Search: (6 2 28 29 30 31)
;; Search: (12 13 2 28 29 30 31)12

;; (best-first-search 1 (is 12) binary-tree (price-is-right 12))
;; Search: (1)
;; Search: (3 2)
;; Search: (7 6 2)
;; Search: (6 2 14 15)
;; Search: (12 2 13 14 15)12

;; (beam-search 1 (is 12) binary-tree (price-is-right 12) 2)
;; Search: (1)
;; Search: (3 2)
;; Search: (7 6)
;; Search: (6 14)
;; Search: (12 13)12


(provide "liv/paip/search")