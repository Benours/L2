(define (accumulate combiner null-value a b)
  (if (> a b)
      null-value
      (combiner a (accumulate combiner null-value (+ a 1) b))))
(define (fact-accu n) (accumulate * 1 1 n))
(define (somme-accu n) (accumulate + 0 1 n))
(define (list-accu n) 