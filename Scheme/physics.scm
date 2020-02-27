(define (calcul-sphere r) (/ (* 4 pi (* r r r)) 3))
(define (calcul-cyl r h) (* pi (* r r) h))
(define (einstein u v) (exact->inexact(/ (+ u v) (+ 1 (/ (* u v) 300000)))))