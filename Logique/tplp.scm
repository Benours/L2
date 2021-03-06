#lang racket

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; 1 Representation des propositions

(define F 'p)
(define G '(! toto))
(define H '(<-> (^ a c) (v (! b) (-> c (^ Bot Top)))))

(define (neg? F) (eq? F '!))
(define (and? F) (eq? F '^))
(define (or? F) (eq? F 'v))
(define (imp? F) (eq? F '->))
(define (equ? F) (eq? F '<->))
(define (top? F) (eq? F 'Top))
(define (bot? F) (eq? F 'Bot))
(define (symbLog? F) (or (top? F) (bot? F) (and? F) (or? F) (neg? F) (imp? F) (equ? F)))
(define (conBin? F) (or (and? F) (or? F) (imp? F) (equ? F)))
(define (symbProp? F) (and (symbol? F) (not (symbLog? F))))
(define (atomicFbf? F) (or (symbProp? F) (top? F) (bot? F)))
(define (fbf? F)
  (cond ((atomicFbf? F) 					   #t )
        ((list? F) (cond ((and (= (length F) 2) (neg? (car F)))    (fbf? (cadr F)))
                         ((and (= (length F) 3) (conBin? (car F))) (and (fbf? (cadr F)) (fbf? (caddr F))) )
                         (else #f)))
        (else #f)))
(define (conRac F) (car F))
(define (fils F) (cadr F))
(define (filsG F) (cadr F))
(define (filsD F) (caddr F))
(define (negFbf? F) (and (not (atomicFbf? F)) (neg? (conRac F))))
(define (conjFbf? F) (and (not (atomicFbf? F)) (and? (conRac F))))
(define (disjFbf? F) (and (not (atomicFbf? F)) (or? (conRac F))))
(define (implFbf? F) (and (not (atomicFbf? F)) (imp? (conRac F))))
(define (equiFbf? F) (and (not (atomicFbf? F)) (equ? (conRac F))))
 
; Q1
(display "\nQ1\n")
(display "F => ") F
(display "G => ") G
(display "H => ") H
(define F1 '(<-> (^ a b) (v (! a) b)))
(define F2 '(v (! (^ a (! b))) (! (-> a b))))
(define F3 '(^ (! (-> a (v a b))) (! (! (^ a (v b (! c)))))))
(define F4 '(^ (v (! a) (v a d)) (^ (v (! d) c) (^ (v c a) (^ (v (! c) (! d)) (v (! b) d))))))

; Q2
(display "\nQ2\n")
(display "(fbf? F) => ") (fbf? F)
(display "(fbf? G) => ") (fbf? G)
(display "(fbf? H) => ") (fbf? H)
(display "(fbf? '(! a b)) => ") (fbf? '(! a b))
(display "(fbf? F1) => ") (fbf? F1)
(display "(fbf? F2) => ") (fbf? F2)
(display "(fbf? F3) => ") (fbf? F3)
(display "(fbf? F4) => ") (fbf? F4)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; 2 Syntaxe des propositions

; Q3
(define (nbc F) (cond ((atomicFbf? F) 0)
                      ((negFbf? F) (+ 1 (nbc (fils F))))
                      (else (+ 1 (nbc (filsG F)) (nbc (filsD F))))))

;Q4
(define (prof F) (cond ((atomicFbf? F) 0)
                      ((negFbf? F) (+ 1 (prof (fils F))))
                      (else (+ 1 (max (prof (filsG F)) (prof (filsD F)))))))

;Q5
(define (ensSP F) (cond ((symbProp? F) (list F))
                        ((atomicFbf? F) (list))
                        ((negFbf? F) (ensSP (fils F)))
                        (else (set-union (ensSP (filsG F)) (ensSP (filsD F))))))

;Q6


;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; 3 Semantique

(define I '((a . 0) (b . 1)))

;Q7
(define I1 '((a . 1) (b . 0) (c . 1)))
(define I2 '((a . 0) (b . 0) (c . 0)))
(define I3 '((a . 1) (b . 1) (c . 1)))

;Q8
(define (intSymb s I)
  (cond ((eq? s (car (set-first I))) (cdr (set-first I)))
        (else (intSymb s (set-rest I)))))

;Q9
(define (intAnd v1 v2) (* v1 v2))
(define intTop 1)
(define intBot 0)
(define (intOr v1 v2) (max v1 v2))
(define (intNeg v1) (if (= v1 1) 0 1))
(define (intImp v1 v2) (if (and (= v1 1) (= v2 0)) 0 1))
(define (intEqu v1 v2) (if (= v1 v2) 1 0))
 
;Q10
(define (valV F I) (cond ((symbProp? F) (intSymb F I))
                         ((negFbf? F) (intNeg (valV (fils F) I)))
                         ((conjFbf? F) (intAnd (valV (filsD F) I) (valV (filsG F) I)))
                         ((disjFbf? F) (intOr (valV (filsD F) I) (valV (filsG F) I)))                         
                         ((implFbf? F) (intImp (valV (filsD F) I) (valV (filsG F) I)))
                         ((equiFbf? F) (intEqu (valV (filsD F) I) (valV (filsG F) I)))
                         ((top? F) (intTop))
                         ((bot? F) (intBot))))
                         
;Q11
(define (modele? F I) (if (= (valV F I) 1) #t #f))
  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; 4 Satisfiabilite, Validite

;Q12
(define EI '(((p . 0) (q . 0))((p . 0) (q . 1))((p . 1) (q . 0))((p . 1) (q . 1))))

;Q13
(define (ensInt ensSymb)
  (if (set-empty? ensSymb) '(())
      (let ( (EI (ensInt (cdr ensSymb))) )
                 (append (map (lambda (I) (set-add I (cons (car ensSymb) 0))) EI)
                         (map (lambda (I) (set-add I (cons (car ensSymb) 1))) EI)))))
                                 
;Q14
(define (satisfiable? F) (ormap (lambda (I) (modele? F I)) (ensInt (ensSP F))))

;Q15
(define (valide? F) (andmap (lambda (I) (modele? F I)) (ensInt (ensSP F))))

;Q16
(define (insatisfiable? F) (null? (filter (lambda (I) (modele? F I)) (ensInt (ensSP F)))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; 5 Equivalence, Consequence

;Q17
(define (equivalent1? F G) (andmap (lambda (I) (= (valV F I) (valV G I)))
                                   (ensInt (append (ensSP F) (ensSP G)))))

;Q17 bis
(define (equivalent2? F G) (valide? (list '<-> F G)))

;Q18
(define (consequence? F1 F2) (andmap (lambda (I) (if (modele? F1 I)
                                                     (modele? F2 I)
                                                     #t))
                                     (ensInt (set-union (ensSP F1) (ensSP F2)))))

;Q19
(define (ensSPallFbf E) (if (set-empty? E) '()
                            (set-union (ensSP (car E)) (ensSPallFbf (cdr E)))))

;Q20
(define (modeleCommun? I EP) (andmap (lambda (F) (modele? F I)) EP))

;Q21
        
;Q22

;Q23
(define (conjonction EF) ; EF est une ensemble de fbf
  (cond  ((set-empty? EF) 'Top)
         ((set-empty? (set-rest EF)) (set-first EF))
         (else (list '^ (set-first EF) (conjonction (set-rest EF))))))

;(define (consequenceV? EH C)
   
;Q24


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; 6 Mise sous forme conjonctive

;Q25
;(define (oteEqu F)
;  (cond ((atomicFbf? F) ...)
;        ((negFbf? F) ...)
;        ((not (equiFbf?  F)) ...)
;        (else  ; c'est <->
;               ...)))

;Q26

;Q27

;Q28
;(define (redNeg F)
;  (cond ((symbProp? F)     ...) ; cas d'un symbole propositionnel
;        ((not (negFbf? F)) ...) ; cas d'un connecteur racine ^ ou v
;        (else  ; cas de la négation en connecteur racine ==> on regarde son fils
;         (cond ((symbProp? (fils F))  	...) ; littéral négatif
;               ((negFbf? (fils F)) 	...) ; deux négations ==> équivalence de la double négation 
;               ((conjFbf? (fils F)) 	...) ; négation d'une conjonction ==> équivalence de De Morgan
;               (else 					...))))) ; négation d'une disjonction ==> équivalence de De Morgan

;Q29
;(define (distOu F)
;  (cond ((symbProp? F)	...)
;        ((negFbf? F)	...)
;        ((conjFbf? F) 	...)
;        (else          ; c'est donc une disjonction
;         (let ( (Fg (distOu (filsG F))) (Fd (distOu (filsD F))) )  
;           (cond ((conjFbf? Fg)	(list '^   (distOu (list 'v (filsG Fg) Fd))   (distOu (list 'v (filsD Fg) Fd))))
;                 ((conjFbf? Fd)	(list '^   (distOu (list 'v Fg (filsG Fd)))   (distOu (list 'v Fg (filsD Fd)))))
;                 (else 			; il n'y a plus de ^ dans les sous-formules
;                  (list 'v   Fg   Fd)))))))

;Q30

  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; 7 Mise sous forme clausale

; Exemple de clause et forme clausale
(define exClause '( p (! r) t)) 
(define exFormeClausale '( (p (! p))  (p q (! r))  ((! r) s)  (p (! r) t)  (p ( ! r))  (r (! t))  (s t) (p (! s))   ((! p ) (! s))))

; Fonction permettant de tester si une fbf est un littéral et d'obtenir le littéral opposé d'un littéral
(define (litteral? F) (or (symbProp? F) (and (negFbf? F) (symbProp? (fils F)))))
(define (oppose L) (if (symbProp? L) (list '! L) (fils L)))
  
; Fonctions permettant de manipuler des ensembles d'ensembles
(define (setSet-member? EC C)
  (cond ((set-empty? EC) #f)
        ((set=? (set-first EC) C) #t)
        (else (setSet-member? (set-rest EC) C))))

(define (setSet-add EC C)
  (cond ((set-empty? EC) (list C))
        ((set=? (set-first EC) C) EC)
        (else (set-add (setSet-add (set-rest EC) C) (set-first EC)))))

(define (setSet-union EC1 EC2)
  (if (set-empty? EC2) EC1
      (setSet-union (setSet-add EC1 (set-first EC2)) (set-rest EC2))))

;Q31
  
;Q32

;Q33

;Q34

;Q35

;Q36


;;;;;;;;;;;;;;;
; 8  Resolution

;Q37
  
;Q38
        
;Q39

;Q40


;;;;;;;;;;;;;;;
; 9 Application

;Q41


;;;;;;;;;;;;;;;
; 10 Evaluation

