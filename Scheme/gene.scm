(define (accumulate combiner null-value a b)
  (if (> a b)
      null-value
      (combiner a (accumulate combiner null-value (+ a 1) b))))
(define (identite x) x)
(define (fact-accu n) (accumulate-term * 1 identite 1 n))
(define (somme-accu n) (accumulate-term + 0 identite 1 n))
(define (list-accu n) (accumulate-term cons '() identite 1 n))
(define (accumulate-term combiner null-value term a b)
  (if (> a b)
      null-value
      (combiner (term a) (accumulate-term combiner null-value term (+ a 1) b))))