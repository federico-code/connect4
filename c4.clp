(deftemplate next-move
  (slot move (type INTEGER) (default ?NONE))
)
 	
(deftemplate dim
  (slot x (type INTEGER) (default ?NONE))
  (slot y (type INTEGER) (default ?NONE))
)	

(deftemplate connect-2-x
  (slot begin (type INTEGER) (default ?NONE))
  (slot end (type INTEGER) (default ?NONE))
  (slot y (type INTEGER) (default ?NONE))
  (slot def-sx (type INTEGER) (default ?NONE))
  (slot def-dx (type INTEGER) (default ?NONE))
)	


(deftemplate connect-2-y
  (slot begin (type INTEGER) (default ?NONE))
  (slot end (type INTEGER) (default ?NONE))
  (slot x (type INTEGER) (default ?NONE))
  (slot def-top (type INTEGER) (default ?NONE))
)	


(deffunction get-all-facts-by-names
  ($?template-names)
  (bind ?facts (create$))
  (progn$ (?f (get-fact-list))
	   (if (member$ (fact-relation ?f) $?template-names)
	       then (bind ?facts (create$ ?facts ?f))))
  ?facts)



(defrule random 
	(dim (x ?x) (y ?y)) 
	(not(next-move (move ?z))) => 
	(assert (next-move (move (random 0 ?x))))
)


;;2-block defense rule (x)

(defrule connect-x-2-blocks
	(G1 ?x ?y)
	(G1 ?x1 ?y)
	(or (test (eq -1 (- ?x ?x1))) (test (eq 1 (- ?x ?x1))))
	=> 
	(assert (connect-2-x (begin ?x) (end ?x1) (y ?y) (def-sx (- ?x 1)) (def-dx (+ ?x1 1)) ))
)

(defrule connect-defense-x-2-blocks-dx 
	(connect-2-x (begin ?start) (end ?finish) (y ?y) (def-dx ?defense-dx) (def-sx ?defense-sx))
	(possible-move ?defense-dx ?y)
	=> 
	(assert (next-move (move ?defense-dx)))
)

(defrule connect-defense-x-sx 
	(connect-2-x (begin ?start) (end ?finish) (y ?y) (def-dx ?defense-dx) (def-sx ?defense-sx))
	(possible-move ?defense-sx ?y)
	=> 
	(assert (next-move (move ?defense-sx)))
)


;;2-block defense rule (y)

(defrule connect-y-2-blocks
	(G1 ?x ?y)
	(G1 ?x ?y1)
	(or (test (eq -1 (- ?y ?y1))) (test (eq 1 (- ?y ?y1))))
	=> 
	(assert (connect-2-y (begin ?y) (end ?y1) (x ?x) (def-top (- ?y 1))  ))
)

(defrule connect-defense-y-top 
	(connect-2-y (begin ?start) (end ?finish) (x ?x) (def-top ?defense-top))
	(possible-move ?x ?defense-top)
	=> 
	(assert (next-move (move ?x)))
)
