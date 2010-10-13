(define-module liv.lists
  (use srfi-1)
  (use srfi-8)
  (export tree-map tree-fold cars cdrs cars+cdrs but-last range list-ref
          dotted-list->list list-repeat))
(select-module liv.lists)

(define (dotted-list->list dl . terminal-fun)
  (let-optionals* terminal-fun ((terminal-fun (lambda _ '())))
    (unfold not-pair? car cdr dl terminal-fun)))

(define (cars . ls)
  (unfold null? caar cdr ls))

(define (cdrs . ls)
  (unfold null? cdar cdr ls))

(define (cars+cdrs ls . rest-lists)
  (let1 lists (cons ls rest-lists)
    (let loop ((lists lists))
      (if (null? lists)
          (values '() '())
          (receive (ls rest-lists)(car+cdr lists)
            (receive (a d)(car+cdr ls)
              (receive (cars cdrs)(loop rest-lists)
                (values (cons a cars)(cons d cdrs)))))))))

(define (tree-fold proc seed tree)
  (fold (lambda (e acc)
          (if (list? e)
              (tree-fold proc acc e)
              (proc e acc))) seed tree))

(define (tree-map proc tree)
  (map (lambda (e)
         (if (list? e)
             (tree-map proc e)
             (proc e))) tree))

(define (but-last ls)
  (let ((kddr (cddr ls)))
    (if (null? kddr)
        ls
        (but-last kddr))))

(define (range min max)
  (iota (+ (- max min) 1) min))

(define (list-repeat n obj)
  (list-tabulate n (lambda args obj)))


(provide "liv/lists")