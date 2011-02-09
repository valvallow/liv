(define-module liv.paip.memo
  (export-all))

(select-module liv.paip.memo)

(define *memo-hash-tables* (make-hash-table))

(define (memo fn fn-name . keys)
  (let-keywords* keys ((key car)(test 'eq?))
    (let1 cache (make-hash-table test)
      (hash-table-put!  *memo-hash-tables* fn-name cache)
      (lambda args
        (let1 key (key args)
          (if-let1 val (and (hash-table-exists? cache key)
                            (hash-table-get cache key))
                   val
                   (rlet1 r (apply fn args)
                          (hash-table-put! cache key r))))))))

;; (define-syntax memoize
;;   (syntax-rules ()
;;     ((_ fn . args)
;;      (set! fn (apply memo fn 'fn args)))))

(define-macro (memoize fn . args)
  `(set! ,fn (apply memo ,fn ',fn ,args)))

(define (clear-memo fn-name)
  (let1 cache (hash-table-get *memo-hash-tables* fn-name #f)
    (when cache (hash-table-clear! cache))))

(define-syntax clear-memoize
  (syntax-rules ()
    ((_ fn)
     (clear-memo 'fn))))

;; (define-syntax define-memo
;;   (syntax-rules ()
;;     ((_ (fn arg ...) body ...)
;;      (begin
;;        (define (fn arg ...)
;;          body ...)
;;        (memoize fn)))))

(define-macro (define-memo name . body)
  `(begin
     (define (,(car name) ,@(cdr name))
       ,@body)
     (memoize ,(car name))))

(provide "liv/paip/memo")