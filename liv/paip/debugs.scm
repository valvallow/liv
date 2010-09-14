;; debug tools
;; PAIP(ŽÀ—p Common Lisp) -  P.116 - 4.10

(define-module liv.paip.debugs
  (use srfi-1)
  (use gauche.parameter)
  (export-all))

(select-module liv.paip.debugs)

(define *dbg-ids* (make-parameter '()))

;; (define (dbg id format-string . args)
;;   (when (member id (*dbg-ids*))
;;     (let1 port (current-error-port)
;;       (newline port)
;;       (apply format port format-string args))))
(define dbg (cut debug-indent <> 0 <> <...>))

(define (debug . ids)
  (*dbg-ids* (lset-union eq? ids (*dbg-ids*))))

(define (undebug . ids)
  (*dbg-ids* (if (null? ids)
                 '()
                 (lset-difference eq? (*dbg-ids*) ids))))

(define (debug-indent id indent format-string . args)
  (when (member id (*dbg-ids*))
    (let1 port (current-error-port)
      (newline port)
      ;; (dotimes (i indent (display " " port)))
      (display (apply string-append (make-list indent " ")) port)
      (apply format port format-string args))))

(provide "liv/paip/debugs")
