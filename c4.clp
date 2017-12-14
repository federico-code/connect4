;;############ salience definitions  ############



(defglobal ?*high-priority* = 1000)
(defglobal ?*middle-priority* = 500)
(defglobal ?*low-priority* = 100)

;;############ template definitions ############

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


(deftemplate connect-3-x
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


(deftemplate connect-3-y
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


;;############ 2-block defense rule (x) ############

(defrule connect-x-2-blocks
	(G1 ?x ?y)
	(G1 ?x1 ?y)
	(test (eq -1 (- ?x ?x1)))
	(not (connect-2-x (begin ?x) (end ?x1) (y ?y) (def-sx  $? ) (def-dx $?) ))
	=> 
	(assert (connect-2-x (begin ?x) (end ?x1) (y ?y) (def-sx (- ?x 1)) (def-dx (+ ?x1 1)) ))
)

(defrule connect-defense-x-2-blocks-dx 
	(connect-2-x (begin ?start) (end ?finish) (y ?y) (def-dx ?defense-dx) (def-sx ?defense-sx))
	(possible-move ?defense-dx ?y)
	=> 
	(assert (next-move (move ?defense-dx)))
)

(defrule connect-defense-x-2-sx 
	(connect-2-x (begin ?start) (end ?finish) (y ?y) (def-dx ?defense-dx) (def-sx ?defense-sx))
	(possible-move ?defense-sx ?y)
	=> 
	(assert (next-move (move ?defense-sx)))
)

;;############ 3-block defense rule (x) ############

(defrule connect-3-blocks
	(declare (salience ?*high-priority*))
	?f1<- (connect-2-x (begin ?x) (end ?x1) (y ?y) (def-sx ?def-sx ) (def-dx $?) )
	?f2<- (connect-2-x (begin ?x1) (end ?x2) (y ?y) (def-sx $? ) (def-dx ?def-dx) )
	(not (connect-3-x (begin ?x) (end ?x2) (y ?y) (def-sx ?def-sx) (def-dx ?def-dx) ))
	=> 
	(assert (connect-3-x (begin ?x) (end ?x2) (y ?y) (def-sx ?def-sx) (def-dx ?def-dx) ))
	(retract ?f1 ?f2)
)

(defrule connect-defense-x-3-blocks-dx 
	(connect-3-x (begin ?start) (end ?finish) (y ?y) (def-dx ?defense-dx) (def-sx ?defense-sx))
	(possible-move ?defense-dx ?y)
	=> 
	(assert (next-move (move ?defense-dx)))
)

(defrule connect-defense-x-3-sx 
	(connect-3-x (begin ?start) (end ?finish) (y ?y) (def-dx ?defense-dx) (def-sx ?defense-sx))
	(possible-move ?defense-sx ?y)
	=> 
	(assert (next-move (move ?defense-sx)))
)

;;############ 2-block defense rule (y) ############

(defrule connect-y-2-blocks
	(G1 ?x ?y)
	(G1 ?x ?y1)
	(test (eq -1 (- ?y ?y1)))
	(not (connect-2-y (begin ?y) (end ?y1) (x ?x) (def-top $?)  ))
	=> 
	(assert (connect-2-y (begin ?y) (end ?y1) (x ?x) (def-top (- ?y 1))  ))
)

(defrule connect-defense-y-2-top 
	(connect-2-y (begin ?start) (end ?finish) (x ?x) (def-top ?defense-top))
	(possible-move ?x ?defense-top)
	=> 
	(assert (next-move (move ?x)))
)


;;############ 3-block defense rule (y) ############

(defrule connect-y-3-blocks
	(G1 ?x ?y)
	(G1 ?x ?y1)
	(G1 ?x ?y2)
	(and (test (eq -1 (- ?y ?y1))) (test (eq -1 (- ?y ?y2))))
	(not (connect-3-y (begin ?y) (end ?y1) (x ?x) (def-top $?)  ))
	=> 
	(assert (connect-3-y (begin ?y) (end ?y1) (x ?x) (def-top (- ?y 1))  ))
)

(defrule connect-defense-y-3-top 
	(connect-3-y (begin ?start) (end ?finish) (x ?x) (def-top ?defense-top))
	(possible-move ?x ?defense-top)
	=> 
	(assert (next-move (move ?x)))
)

