;;############ salience definitions  ############

(defglobal ?*connect-priority* = 5000)
(defglobal ?*move-high-priority* = 1000)
(defglobal ?*move-middle-priority* = 500)
(defglobal ?*move-low-priority* = 100)


;;############ template definitions ############

(deftemplate random-move
  (slot move (type INTEGER) (default ?NONE))
)

(deftemplate next-move
  (slot move (type INTEGER) (default ?NONE))
)

(deftemplate dim
  (slot x (type INTEGER) (default ?NONE))
  (slot y (type INTEGER) (default ?NONE))
)	

(deftemplate connect-2-x
  (slot player (type INTEGER)(default ?NONE))
  (slot begin (type INTEGER) (default ?NONE))
  (slot end (type INTEGER) (default ?NONE))
  (slot y (type INTEGER) (default ?NONE))
  (slot next-sx (type INTEGER) (default ?NONE))
  (slot next-dx (type INTEGER) (default ?NONE))
)	


(deftemplate connect-3-x
  (slot player (type INTEGER)(default ?NONE))
  (slot begin (type INTEGER) (default ?NONE))
  (slot end (type INTEGER) (default ?NONE))
  (slot y (type INTEGER) (default ?NONE))
  (slot next-sx (type INTEGER) (default ?NONE))
  (slot next-dx (type INTEGER) (default ?NONE))
)	

(deftemplate connect-2-y
  (slot player (type INTEGER)(default ?NONE))
  (slot begin (type INTEGER) (default ?NONE))
  (slot end (type INTEGER) (default ?NONE))
  (slot x (type INTEGER) (default ?NONE))
  (slot next-top (type INTEGER) (default ?NONE))
)	


(deftemplate connect-3-y
  (slot player (type INTEGER)(default ?NONE))
  (slot begin (type INTEGER) (default ?NONE))
  (slot end (type INTEGER) (default ?NONE))
  (slot x (type INTEGER) (default ?NONE))
  (slot next-top (type INTEGER) (default ?NONE))
)	


(deftemplate connect-2-diagdx
  (slot player (type INTEGER)(default ?NONE))

  (slot begin-x (type INTEGER) (default ?NONE))  
  (slot begin-y (type INTEGER) (default ?NONE))

  (slot end-x (type INTEGER) (default ?NONE))
  (slot end-y (type INTEGER) (default ?NONE))

  (slot next-sx-x (type INTEGER) (default ?NONE))
  (slot next-sx-y (type INTEGER) (default ?NONE))
  (slot next-dx-x (type INTEGER) (default ?NONE))
  (slot next-dx-y (type INTEGER) (default ?NONE))
)	


(deftemplate connect-2-diagsx
  (slot player (type INTEGER)(default ?NONE))

  (slot begin-x (type INTEGER) (default ?NONE))  
  (slot begin-y (type INTEGER) (default ?NONE))

  (slot end-x (type INTEGER) (default ?NONE))
  (slot end-y (type INTEGER) (default ?NONE))

  (slot next-sx-x (type INTEGER) (default ?NONE))
  (slot next-sx-y (type INTEGER) (default ?NONE))
  (slot next-dx-x (type INTEGER) (default ?NONE))
  (slot next-dx-y (type INTEGER) (default ?NONE))
)	


(deftemplate connect-3-diagdx
  (slot player (type INTEGER)(default ?NONE))

  (slot begin-x (type INTEGER) (default ?NONE))  
  (slot begin-y (type INTEGER) (default ?NONE))

  (slot end-x (type INTEGER) (default ?NONE))
  (slot end-y (type INTEGER) (default ?NONE))

  (slot next-sx-x (type INTEGER) (default ?NONE))
  (slot next-sx-y (type INTEGER) (default ?NONE))
  (slot next-dx-x (type INTEGER) (default ?NONE))
  (slot next-dx-y (type INTEGER) (default ?NONE))
)	


(deftemplate connect-3-diagsx
  (slot player (type INTEGER)(default ?NONE))

  (slot begin-x (type INTEGER) (default ?NONE))  
  (slot begin-y (type INTEGER) (default ?NONE))

  (slot end-x (type INTEGER) (default ?NONE))
  (slot end-y (type INTEGER) (default ?NONE))

  (slot next-sx-x (type INTEGER) (default ?NONE))
  (slot next-sx-y (type INTEGER) (default ?NONE))
  (slot next-dx-x (type INTEGER) (default ?NONE))
  (slot next-dx-y (type INTEGER) (default ?NONE))
)	

;;####################end template definitions#######################


;;Function for retriving all the facts that goes by the name passed in input
(deffunction get-all-facts-by-names
  ($?template-names)
  (bind ?facts (create$))
  (progn$ (?f (get-fact-list))
	   (if (member$ (fact-relation ?f) $?template-names)
	       then (bind ?facts (create$ ?facts ?f))))
  ?facts)


;;Rule that chose a random move within the bounds of the game board
(defrule random 
	(dim (x ?x) (y ?y)) 
	(not(random-move (move $?)))
	=> 
	(assert (random-move (move (random 0 ?x))))
)

;;Rule that chose a random move within the bounds of the game board
(defrule random-retract
	?f<-(random-move (move ?x))
	(not(possible-move ?x ?y))
	=> 
	(retract ?f)
)

;;Rule that chose a random move within the bounds of the game board
(defrule random-activate
	?f<-(random-move (move ?x))
	(possible-move ?x ?y)
	=> 
	(assert (next-move(move ?x)))
	(retract ?f)
)

;; ___________________________________________________________________________________
;;|																					  |
;;|				  RULES FOR SPOTTING CONNECTIONS OF THE OPPONENT BLOCKS				  |
;;|___________________________________________________________________________________|
;;#####################################################################################
;;This is a group of rules that helps visualising the opponent strategy to win the match.
;;All these rules have the highest priority to prevent the assertion of a next-move fact
;;that will stop the inference engine. 
;;#####################################################################################

;;Rule that spots if the opponent aligns two blocks on the x axis.
(defrule connect-x-2-blocks
	(declare (salience ?*connect-priority*))
	(G ?player ?x ?y)
	(G ?player ?x1 ?y)
	(test (eq -1 (- ?x ?x1)))
	(and
		(not (connect-3-x (player ?player)(begin ?x) (end $?) (y ?y) (next-sx  $? ) (next-dx $?)) )
		(not (connect-3-x (player ?player)(begin $?) (end ?x1) (y ?y) (next-sx  $? ) (next-dx $?)) )
	
	)
	(not (connect-2-x (player ?player) (begin ?x) (end ?x1) (y ?y) (next-sx  $? ) (next-dx $?) ))
	=> 
	(assert (connect-2-x (player ?player) (begin ?x) (end ?x1) (y ?y) (next-sx (- ?x 1)) (next-dx (+ ?x1 1)) ))
)


;;Rule that spots if the opponent aligns three blocks on the x axis, removing the redundants
;;two facts connect-2-x of which the new three block is composed.
(defrule connect-3-blocks
	(declare (salience ?*connect-priority*))
	?f1<- (connect-2-x (player ?player) (begin ?x) (end ?x1) (y ?y) (next-sx ?next-sx ) (next-dx $?) )
	?f2<- (connect-2-x (player ?player) (begin ?x1) (end ?x2) (y ?y) (next-sx $? ) (next-dx ?next-dx) )
	(not (connect-3-x (player ?player) (begin ?x) (end ?x2) (y ?y) (next-sx ?next-sx) (next-dx ?next-dx) ))
	=> 
	(assert (connect-3-x (player ?player) (begin ?x) (end ?x2) (y ?y) (next-sx ?next-sx) (next-dx ?next-dx) ))
	(retract ?f1 ?f2)
)


;;Rule that spots if the opponent aligns two blocks on the y axis.
(defrule connect-y-2-blocks
	(declare (salience ?*connect-priority*))
	(G ?player ?x ?y)
	(G ?player ?x ?y1)
	(test (eq -1 (- ?y ?y1)))
	(and
		(not (connect-3-y (player ?player)(begin ?y) (end $?) (x ?x) (next-top $?)) )
		(not (connect-3-y (player ?player)(begin $?) (end ?y1) (x ?x) (next-top $?)) )
	)
	(not (connect-2-y (player ?player)(begin ?y) (end ?y1) (x ?x) (next-top $?)  ))
	=> 
	(assert (connect-2-y (player ?player)(begin ?y) (end ?y1) (x ?x) (next-top (- ?y 1))  ))
)

;;Rule that spots if the opponent aligns three blocks on the y axis, removing the redundants
;;two facts connect-2-y of which the new three block is composed.
(defrule connect-y-3-blocks
	(declare (salience ?*connect-priority*))
	?f1<- (connect-2-y (player ?player)(begin ?y) (end ?y1) (x ?x) (next-top $?) )
	?f2<- (connect-2-y (player ?player)(begin ?y1) (end ?y2) (x ?x) (next-top ?next-top) )
	(not (connect-3-y (player ?player)(begin ?y) (end ?y2) (x ?x) (next-top $?) ))
	=> 
	(assert (connect-3-y (player ?player)(begin ?y) (end ?y2) (x ?x) (next-top (- ?next-top 1) )))
	(retract ?f1 ?f2)
)

;;Rule that spots if the opponent aligns two blocks on the diagonal to the right (45° from the y axis).
(defrule connect-diagdx-2-blocks
	(declare (salience ?*connect-priority*))
	(G ?player ?x ?y)
	(G ?player ?x1 ?y1)
	(test (eq -1 (- ?x ?x1)))
	(test (eq 1 (- ?y ?y1)))
	(and
		(not (connect-3-diagdx (player ?player)
							   (begin-x ?x) (begin-y ?y) 							  
							   (end-x $?) (end-y $?) 
							   (next-sx-x $?) (next-sx-y $?) 
							   (next-dx-x $?)(next-dx-y $?)
 		))
		(not (connect-3-diagdx (player ?player)
								(begin-x $?) (begin-y $?) 							  
							   (end-x ?x1) (end-y ?y1) 
							   (next-sx-x $?) (next-sx-y $?) 
							   (next-dx-x $?)(next-dx-y $?)
 		))
 	)
	(not (connect-2-diagdx (player ?player)
							(begin-x ?x) (begin-y ?y) 
							(end-x ?x1) (end-y ?y1) 
							(next-sx-x $?) (next-sx-y $?) 
							(next-dx-x $?)(next-dx-y $?) 
	))
	=> 
	(assert (connect-2-diagdx (player ?player)
								(begin-x ?x) (begin-y ?y)  
							  (end-x ?x1) (end-y ?y1) 
							  (next-sx-x (- ?x 1)) (next-sx-y (+ ?y 1)) 
							  (next-dx-x (+ ?x1 1)) (next-dx-y (- ?y1 1)) 
	))
)

;;Rule that spots if the opponent aligns three blocks on the right diagonal, removing the redundants
;;two facts connect-2-diagdx of which the new three block is composed.
(defrule connect-diagdx-3-blocks
	(declare (salience ?*connect-priority*))
	?f1<-(connect-2-diagdx (player ?player)
								(begin-x ?x) (begin-y ?y)  
							  (end-x ?x1) (end-y ?y1) 
							  (next-sx-x ?next-sx-x) (next-sx-y ?next-sx-y) 
							  (next-dx-x $?) (next-dx-y $?)
		 ) 

	?f2<-(connect-2-diagdx (player ?player)
							(begin-x ?x1) (begin-y ?y1)  
						  (end-x ?x2) (end-y ?y2) 
						  (next-sx-x $?) (next-sx-y $?) 
						  (next-dx-x ?next-dx-x) (next-dx-y ?next-dx-y)
	 ) 
	(not(connect-3-diagdx (player ?player)
							(begin-x ?x) (begin-y ?y)  
						  (end-x ?x2) (end-y ?y2) 
						  (next-sx-x $?) (next-sx-y $?) 
						  (next-dx-x $?) (next-dx-y $?)
	))
	=> 
	(assert (connect-3-diagdx (player ?player)
								(begin-x ?x) (begin-y ?y)  
							  (end-x ?x2) (end-y ?y2) 
							  (next-sx-x ?next-sx-x) (next-sx-y ?next-sx-y) 
							  (next-dx-x ?next-dx-x) (next-dx-y ?next-dx-y) 
	))
	(retract ?f1 ?f2)

)


;;Rule that spots if the opponent aligns two blocks on the diagonal to the left (-45° from the y axis).
(defrule connect-diagsx-2-blocks
	(declare (salience ?*connect-priority*))
	(G ?player ?x ?y)
	(G ?player ?x1 ?y1)
	(test (eq -1 (- ?x ?x1)))
	(test (eq -1 (- ?y ?y1)))
	(and
		(not (connect-3-diagsx (player ?player)
								(begin-x ?x) (begin-y ?y) 							  
							   (end-x $?) (end-y $?) 
							   (next-sx-x $?) (next-sx-y $?) 
							   (next-dx-x $?)(next-dx-y $?)
 		))
		(not (connect-3-diagsx (player ?player)
								(begin-x $?) (begin-y $?) 							  
							   (end-x ?x1) (end-y ?y1) 
							   (next-sx-x $?) (next-sx-y $?) 
							   (next-dx-x $?)(next-dx-y $?)
 		))
 	)
	(not (connect-2-diagsx (player ?player)
							(begin-x ?x) (begin-y ?y) 
							(end-x ?x1) (end-y ?y1) 
							(next-sx-x $?) (next-sx-y $?) 
							(next-dx-x $?)(next-dx-y $?) 
	))
	=> 
	(assert (connect-2-diagsx (player ?player)
								(begin-x ?x) (begin-y ?y)  
							  (end-x ?x1) (end-y ?y1) 
							  (next-sx-x (- ?x 1)) (next-sx-y (- ?y 1)) 
							  (next-dx-x (+ ?x1 1)) (next-dx-y (+ ?y1 1)) 
	))
)


;;Rule that spots if the opponent aligns three blocks on the left diagonal, removing the redundants
;;two facts connect-2-diagsx of which the new three block is composed.
(defrule connect-diagsx-3-blocks
	(declare (salience ?*connect-priority*))
	?f1<-(connect-2-diagsx (player ?player)
							(begin-x ?x) (begin-y ?y)  
							  (end-x ?x1) (end-y ?y1) 
							  (next-sx-x ?next-sx-x) (next-sx-y ?next-sx-y) 
							  (next-dx-x $?) (next-dx-y $?)
		 ) 

	?f2<-(connect-2-diagsx (player ?player)
							(begin-x ?x1) (begin-y ?y1)  
						  (end-x ?x2) (end-y ?y2) 
						  (next-sx-x $?) (next-sx-y $?) 
						  (next-dx-x ?next-dx-x) (next-dx-y ?next-dx-y)
	 ) 
	(not(connect-3-diagsx (player ?player)
						 (begin-x ?x) (begin-y ?y)  
						  (end-x ?x2) (end-y ?y2) 
						  (next-sx-x $?) (next-sx-y $?) 
						  (next-dx-x $?) (next-dx-y $?)
	))
	=> 
	(assert (connect-3-diagsx (player ?player)
								(begin-x ?x) (begin-y ?y)  
							  (end-x ?x2) (end-y ?y2) 
							  (next-sx-x ?next-sx-x) (next-sx-y ?next-sx-y) 
							  (next-dx-x ?next-dx-x) (next-dx-y ?next-dx-y) 
	))
	(retract ?f1 ?f2)

)

;; ___________________________________________________________________________________
;;|																					  |
;;|			 (END) RULES FOR SPOTTING CONNECTIONS OF THE OPPONENT BLOCKS			  |
;;|___________________________________________________________________________________|



