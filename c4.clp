(deftemplate next-move
  (slot move (type INTEGER) (default ?NONE))
)
 	
(deftemplate dim
  (slot x (type INTEGER) (default ?NONE))
  (slot y (type INTEGER) (default ?NONE))
)	


(deffunction get-all-facts-by-names
  ($?template-names)
  (bind ?facts (create$))
  (progn$ (?f (get-fact-list))
	   (if (member$ (fact-relation ?f) $?template-names)
	       then (bind ?facts (create$ ?facts ?f))))
  ?facts)


;;(defrule random (dim (x ?x) (y ?y)) (not(next-move (move ?z)))=> (assert (next-move (move (random 0 (- ?x 1))))))

<<<<<<< HEAD
(defrule random (dim (x ?x) (y ?y)) (not(next-move (move ?z)))=> (assert (next-move (move 1))))


;;(defrule dumb-defense-y (G1 ?x ?y) (not(next-move (move ?z))) => (assert (next-move(move ?x))))
;;(defrule dumb-defense-sx (G1 ?x ?y) (not(next-move (move ?z))) => (assert (next-move(move (- ?x 1)))))  
;;(defrule dumb-defense-dx (G1 ?x ?y) (not(next-move (move ?z))) => (assert (next-move(move (+ ?x 1)))))

(defrule block-three-x (G1 ?x ?y) (G1 ?x1 ?y) (G1 ?x2 ?y) (not(or (G1 ?a ?y) (G2 ?a ?y))) (not(next-move(move ?z))) => (assert(next-move(move ?a))))
=======
(defrule dumb-defense (G1 ?x ?y) => (assert (next-move(move ?x))))
  
(defrule block-three-x (G1 ?x ?y) (G1 ?x1 ?y) (G1 ?x2 ?y) (not(or(G2 ?a ?y) (G1 ?a ?y))) (not(next-move(move ?z))) => (assert(next-move(move ?a))))
>>>>>>> 304e14e977fccb3ee754559030d084e7bf8e6cb7
