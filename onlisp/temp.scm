;; on lisp
;; http://www.komaba.utmc.or.jp/~flatline/onlispjhtml/

(define-module liv.onlisp.temp
  ;; (use srfi-1)
  ;; (use util.list)
  ;; (use gauche.collection)
  (export-all))

(select-module liv.onlisp.temp)

;; (define (fif pred then . else)
;;   (let-optionals* else ((else #f))
;;     (lambda x
;;       (if (apply pred x)
;;           (apply then x)
;;           (if else
;;               (apply else x))))))

;; (define (fint fn . funs)
;;   (if (null? funs)
;;       fn
;;       (let1 chain (apply fint funs)
;;         (lambda x
;;           (and (apply fn x)(apply chain x))))))

;; (define (fun fn . funs)
;;   (if (null? funs)
;;       fn
;;       (let1 chain (apply fint funs)
;;         (lambda x
;;           (or (apply fn x)(apply chain x))))))


(provide "liv/onlisp/temp")

