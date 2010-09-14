;; on lisp
;; http://www.komaba.utmc.or.jp/~flatline/onlispjhtml/

(define-module liv.onlisp.utils
  (use srfi-1)
  (use util.list)
  (export-all))

(define (single ls)
  (and (pair? ls)
       (null? (cdr ls))))

(define (append1 ls obj)
  (append ls (list obj)))

(define (append1! ls obj)
  (append! ls (list obj)))

(define (mklist obj)
  (if (pair? obj)
      obj
      (list obj)))

(define (flatten tree)
  (if (list? tree)
      (append (flatten (car tree))
              (if (null? (cdr tree))
                  '()
                  (flatten (cdr tree))))
      (mklist tree)))

(define group slices)

(define (prune test tree)
  (fold-right (lambda (e acc)
                (if (pair? e)
                    (cons (prune test e) acc)
                    (if (test e)
                        acc
                        (cons e acc))))
              '() tree))

(define (before x y ls)
  (and (not (null? ls))
       (let1 a (car ls)
         (cond ((test y a) => (lambda (b)
                                (not b)))
               ((test x a) ls)
               (else (before x y (cdr ls) :test test))))))

(define (after x y ls)
  (let1 rest (before y x ls)
    (and rest (member x rest))))

(define (duplicate obj ls)
  (member obj (cdr (member obj ls))))

(define (split-if fn ls)
  (let rec ((ls ls)(acc '()))
    (if (or (null? ls)
            (fn (car ls)))
        (values (reverse acc) ls)
        (rec (cdr ls)(cons (car ls) acc)))))

(define (most fn ls)
  (if (null? ls)
      (values '() -inf.0)
      (with-module gauche.collection
        (fold2 (lambda (e ret max)
                 (let1 score (fn e)
                   (if (< max score)
                       (values e score)
                       (values ret max)))) '() -inf.0 ls))))

(define (best fn ls)
  (if (null? ls)
      '()
      (fold (lambda (e acc)
              (if (fn e acc)
                  e
                  acc))(car ls) ls)))

(define (mostn fn ls)
  (if (null? ls)
      (values '() -inf.0)
      (with-module gauche.collection
        (fold2 (lambda (e ret max)
                 (let1 score (fn e)
                   (cond ((< max score)(values (list e) score))
                         ((= max score)(values (append ret (list e)) max))
                         (else (values ret max)))))
               '() -inf.0 ls))))

(mostn length '((a b)(a b c)(d)(e f g)))


(provide "lib.onlisp.utils")