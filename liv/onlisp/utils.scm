;; on lisp
;; http://www.komaba.utmc.or.jp/~flatline/onlispjhtml/

(define-module liv.onlisp.utils
  (use srfi-1)
  (use util.list)
  (use gauche.collection)
  (export-all))

(select-module liv.onlisp.utils)

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
      (fold2 (lambda (e ret max)
               (let1 score (fn e)
                 (if (< max score)
                     (values e score)
                     (values ret max)))) '() -inf.0 ls)))

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
      (fold2 (lambda (e ret max)
               (let1 score (fn e)
                 (cond ((< max score)(values (list e) score))
                       ((= max score)(values (append ret (list e)) max))
                       (else (values ret max)))))
             '() -inf.0 ls)))

(define (mapa-b fn a b . step)
  (let-optionals* step ((step 1))
    (let rec ((i a)(end b)(acc '()))
      (if (< end i)
           (reverse acc)
           (rec (+ i step) end (cons (fn i) acc))))))

(define (map0-n fn n)
  (mapa-b fn 0 n))

(define (map1-n fn n)
  (mapa-b fn 1 n))

(define (map-> fn start test-fn succ-fn)
  (let rec ((i start)(acc '()))
    (if (test-fn i)
        (reverse acc)
        (rec (succ-fn i)(cons (fn i) acc)))))

(define (mappend fn . lss)
  (apply append (apply map fn lss)))

(define (rmap fn . lss)
  (apply map (lambda (e)
               (if (list? e)
                   (rmap fn e)
                   (fn e))) lss))

(define (mkstr . args)
  (with-output-to-string
    (lambda ()
      (dolist (a args)
        (display a)))))

(define (symb . args)
  (string->symbol (apply mkstr args)))

(define (explode sym)
  (map (compose string->symbol string)
       ((compose string->list symbol->string) sym)))

(define (fif pred then . else)
  (let-optionals* else ((else #f))
    (lambda x
      (if (apply pred x)
          (apply then x)
          (if else
              (apply else x))))))

(define (fint fn . funs)
  (if (null? funs)
      fn
      (let1 chain (apply fint funs)
        (lambda x
          (and (apply fn x)(apply chain x))))))

(define (fun fn . funs)
  (if (null? funs)
      fn
      (let1 chain (apply fint funs)
        (lambda x
          (or (apply fn x)(apply chain x))))))

(define (lrec rec . base)
  (let-optionals* base ((base '()))
    (letrec ((self (lambda (lst)
                     (if (null? lst)
                         (if (procedure? base)
                             (base)
                             base)
                         (rec (car lst)
                              (lambda ()
                                (self (cdr lst))))))))
      self)))


(provide "liv/onlisp/utils")

