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


(deftemplate connect-2-diagdx
  (slot begin-x (type INTEGER) (default ?NONE))  
  (slot begin-y (type INTEGER) (default ?NONE))

  (slot end-x (type INTEGER) (default ?NONE))
  (slot end-y (type INTEGER) (default ?NONE))

  (slot def-sx-x (type INTEGER) (default ?NONE))
  (slot def-sx-y (type INTEGER) (default ?NONE))
  (slot def-dx-x (type INTEGER) (default ?NONE))
  (slot def-dx-y (type INTEGER) (default ?NONE))
)	


(deftemplate connect-2-diagsx
  (slot begin-x (type INTEGER) (default ?NONE))  
  (slot begin-y (type INTEGER) (default ?NONE))

  (slot end-x (type INTEGER) (default ?NONE))
  (slot end-y (type INTEGER) (default ?NONE))

  (slot def-sx-x (type INTEGER) (default ?NONE))
  (slot def-sx-y (type INTEGER) (default ?NONE))
  (slot def-dx-x (type INTEGER) (default ?NONE))
  (slot def-dx-y (type INTEGER) (default ?NONE))
)	


(deftemplate connect-3-diagdx
  (slot begin-x (type INTEGER) (default ?NONE))  
  (slot begin-y (type INTEGER) (default ?NONE))

  (slot end-x (type INTEGER) (default ?NONE))
  (slot end-y (type INTEGER) (default ?NONE))

  (slot def-sx-x (type INTEGER) (default ?NONE))
  (slot def-sx-y (type INTEGER) (default ?NONE))
  (slot def-dx-x (type INTEGER) (default ?NONE))
  (slot def-dx-y (type INTEGER) (default ?NONE))
)	


(deftemplate connect-3-diagsx
  (slot begin-x (type INTEGER) (default ?NONE))  
  (slot begin-y (type INTEGER) (default ?NONE))

  (slot end-x (type INTEGER) (default ?NONE))
  (slot end-y (type INTEGER) (default ?NONE))

  (slot def-sx-x (type INTEGER) (default ?NONE))
  (slot def-sx-y (type INTEGER) (default ?NONE))
  (slot def-dx-x (type INTEGER) (default ?NONE))
  (slot def-dx-y (type INTEGER) (default ?NONE))
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
	(G1 ?x ?y)
	(G1 ?x1 ?y)
	(test (eq -1 (- ?x ?x1)))
	(and
		(not (connect-3-x (begin ?x) (end $?) (y ?y) (def-sx  $? ) (def-dx $?)) )
		(not (connect-3-x (begin $?) (end ?x1) (y ?y) (def-sx  $? ) (def-dx $?)) )
	
	)
	(not (connect-2-x (begin ?x) (end ?x1) (y ?y) (def-sx  $? ) (def-dx $?) ))
	=> 
	(assert (connect-2-x (begin ?x) (end ?x1) (y ?y) (def-sx (- ?x 1)) (def-dx (+ ?x1 1)) ))
)


;;Rule that spots if the opponent aligns three blocks on the x axis, removing the redundants
;;two facts connect-2-x of which the new three block is composed.
(defrule connect-3-blocks
	(declare (salience ?*connect-priority*))
	?f1<- (connect-2-x (begin ?x) (end ?x1) (y ?y) (def-sx ?def-sx ) (def-dx $?) )
	?f2<- (connect-2-x (begin ?x1) (end ?x2) (y ?y) (def-sx $? ) (def-dx ?def-dx) )
	(not (connect-3-x (begin ?x) (end ?x2) (y ?y) (def-sx ?def-sx) (def-dx ?def-dx) ))
	=> 
	(assert (connect-3-x (begin ?x) (end ?x2) (y ?y) (def-sx ?def-sx) (def-dx ?def-dx) ))
	(retract ?f1 ?f2)
)


;;Rule that spots if the opponent aligns two blocks on the y axis.
(defrule connect-y-2-blocks
	(declare (salience ?*connect-priority*))
	(G1 ?x ?y)
	(G1 ?x ?y1)
	(test (eq -1 (- ?y ?y1)))
	(and
		(not (connect-3-y (begin ?y) (end $?) (x ?x) (def-top $?)) )
		(not (connect-3-y (begin $?) (end ?y1) (x ?x) (def-top $?)) )
	)
	(not (connect-2-y (begin ?y) (end ?y1) (x ?x) (def-top $?)  ))
	=> 
	(assert (connect-2-y (begin ?y) (end ?y1) (x ?x) (def-top (- ?y 1))  ))
)

;;Rule that spots if the opponent aligns three blocks on the y axis, removing the redundants
;;two facts connect-2-y of which the new three block is composed.
(defrule connect-y-3-blocks
	(declare (salience ?*connect-priority*))
	?f1<- (connect-2-y (begin ?y) (end ?y1) (x ?x) (def-top $?) )
	?f2<- (connect-2-y (begin ?y1) (end ?y2) (x ?x) (def-top ?def-top) )
	(not (connect-3-y (begin ?y) (end ?y2) (x ?x) (def-top $?) ))
	=> 
	(assert (connect-3-y (begin ?y) (end ?y2) (x ?x) (def-top (- ?def-top 1) )))
	(retract ?f1 ?f2)
)

;;Rule that spots if the opponent aligns two blocks on the diagonal to the right (45° from the y axis).
(defrule connect-diagdx-2-blocks
	(declare (salience ?*connect-priority*))
	(G1 ?x ?y)
	(G1 ?x1 ?y1)
	(test (eq -1 (- ?x ?x1)))
	(test (eq 1 (- ?y ?y1)))
	(and
		(not (connect-3-diagdx (begin-x ?x) (begin-y ?y) 							  
							   (end-x $?) (end-y $?) 
							   (def-sx-x $?) (def-sx-y $?) 
							   (def-dx-x $?)(def-dx-y $?)
 		))
		(not (connect-3-diagdx (begin-x $?) (begin-y $?) 							  
							   (end-x ?x1) (end-y ?y1) 
							   (def-sx-x $?) (def-sx-y $?) 
							   (def-dx-x $?)(def-dx-y $?)
 		))
 	)
	(not (connect-2-diagdx (begin-x ?x) (begin-y ?y) 
							(end-x ?x1) (end-y ?y1) 
							(def-sx-x $?) (def-sx-y $?) 
							(def-dx-x $?)(def-dx-y $?) 
	))
	=> 
	(assert (connect-2-diagdx (begin-x ?x) (begin-y ?y)  
							  (end-x ?x1) (end-y ?y1) 
							  (def-sx-x (- ?x 1)) (def-sx-y (+ ?y 1)) 
							  (def-dx-x (+ ?x1 1)) (def-dx-y (- ?y1 1)) 
	))
)

;;Rule that spots if the opponent aligns three blocks on the right diagonal, removing the redundants
;;two facts connect-2-diagdx of which the new three block is composed.
(defrule connect-diagdx-3-blocks
	(declare (salience ?*connect-priority*))
	?f1<-(connect-2-diagdx (begin-x ?x) (begin-y ?y)  
							  (end-x ?x1) (end-y ?y1) 
							  (def-sx-x ?def-sx-x) (def-sx-y ?def-sx-y) 
							  (def-dx-x $?) (def-dx-y $?)
		 ) 

	?f2<-(connect-2-diagdx (begin-x ?x1) (begin-y ?y1)  
						  (end-x ?x2) (end-y ?y2) 
						  (def-sx-x $?) (def-sx-y $?) 
						  (def-dx-x ?def-dx-x) (def-dx-y ?def-dx-y)
	 ) 
	(not(connect-3-diagdx (begin-x ?x) (begin-y ?y)  
						  (end-x ?x2) (end-y ?y2) 
						  (def-sx-x $?) (def-sx-y $?) 
						  (def-dx-x $?) (def-dx-y $?)
	))
	=> 
	(assert (connect-3-diagdx (begin-x ?x) (begin-y ?y)  
							  (end-x ?x2) (end-y ?y2) 
							  (def-sx-x ?def-sx-x) (def-sx-y ?def-sx-y) 
							  (def-dx-x ?def-dx-x) (def-dx-y ?def-dx-y) 
	))
	(retract ?f1 ?f2)

)


;;Rule that spots if the opponent aligns two blocks on the diagonal to the left (-45° from the y axis).
(defrule connect-diagsx-2-blocks
	(declare (salience ?*connect-priority*))
	(G1 ?x ?y)
	(G1 ?x1 ?y1)
	(test (eq -1 (- ?x ?x1)))
	(test (eq -1 (- ?y ?y1)))
	(and
		(not (connect-3-diagsx (begin-x ?x) (begin-y ?y) 							  
							   (end-x $?) (end-y $?) 
							   (def-sx-x $?) (def-sx-y $?) 
							   (def-dx-x $?)(def-dx-y $?)
 		))
		(not (connect-3-diagsx (begin-x $?) (begin-y $?) 							  
							   (end-x ?x1) (end-y ?y1) 
							   (def-sx-x $?) (def-sx-y $?) 
							   (def-dx-x $?)(def-dx-y $?)
 		))
 	)
	(not (connect-2-diagsx (begin-x ?x) (begin-y ?y) 
							(end-x ?x1) (end-y ?y1) 
							(def-sx-x $?) (def-sx-y $?) 
							(def-dx-x $?)(def-dx-y $?) 
	))
	=> 
	(assert (connect-2-diagsx (begin-x ?x) (begin-y ?y)  
							  (end-x ?x1) (end-y ?y1) 
							  (def-sx-x (- ?x 1)) (def-sx-y (- ?y 1)) 
							  (def-dx-x (+ ?x1 1)) (def-dx-y (+ ?y1 1)) 
	))
)


;;Rule that spots if the opponent aligns three blocks on the left diagonal, removing the redundants
;;two facts connect-2-diagsx of which the new three block is composed.
(defrule connect-diagsx-3-blocks
	(declare (salience ?*connect-priority*))
	?f1<-(connect-2-diagsx (begin-x ?x) (begin-y ?y)  
							  (end-x ?x1) (end-y ?y1) 
							  (def-sx-x ?def-sx-x) (def-sx-y ?def-sx-y) 
							  (def-dx-x $?) (def-dx-y $?)
		 ) 

	?f2<-(connect-2-diagsx (begin-x ?x1) (begin-y ?y1)  
						  (end-x ?x2) (end-y ?y2) 
						  (def-sx-x $?) (def-sx-y $?) 
						  (def-dx-x ?def-dx-x) (def-dx-y ?def-dx-y)
	 ) 
	(not(connect-3-diagsx (begin-x ?x) (begin-y ?y)  
						  (end-x ?x2) (end-y ?y2) 
						  (def-sx-x $?) (def-sx-y $?) 
						  (def-dx-x $?) (def-dx-y $?)
	))
	=> 
	(assert (connect-3-diagsx (begin-x ?x) (begin-y ?y)  
							  (end-x ?x2) (end-y ?y2) 
							  (def-sx-x ?def-sx-x) (def-sx-y ?def-sx-y) 
							  (def-dx-x ?def-dx-x) (def-dx-y ?def-dx-y) 
	))
	(retract ?f1 ?f2)

)

;; ___________________________________________________________________________________
;;|																					  |
;;|			 (END) RULES FOR SPOTTING CONNECTIONS OF THE OPPONENT BLOCKS			  |
;;|___________________________________________________________________________________|




;; ___________________________________________________________________________________
;;|																					  |
;;|								RULES FOR BASIC DEFENSE    							  |
;;|___________________________________________________________________________________|
;;#####################################################################################
;;This is a group of rules that helps chosing the CPU next move based on a simple defense 
;;strategy.
;;All these rules will assert a 'next-move' fact that will stop the inference engine. 
;;#####################################################################################

;;________________________________________X AXIS_____________________________________

;;Rule that will stop the opponent's alignement of two blocks on the x axis by placing  
;;a block on the next right of the opponent's connection.
(defrule connect-defense-x-2-blocks-dx 
	(connect-2-x (begin ?start) (end ?finish) (y ?y) (def-dx ?defense-dx) (def-sx ?defense-sx))
	(possible-move ?defense-dx ?y)
	=> 
	(assert (next-move (move ?defense-dx)))
)

;;Rule that will stop the opponent's alignement of two blocks on the x axis by placing  
;;a block on the next left of the opponent's connection.
(defrule connect-defense-x-2-sx 
	(connect-2-x (begin ?start) (end ?finish) (y ?y) (def-dx ?defense-dx) (def-sx ?defense-sx))
	(possible-move ?defense-sx ?y)
	=> 
	(assert (next-move (move ?defense-sx)))
)

;;Rule that will stop the opponent's alignement of three blocks on the x axis by placing  
;;a block on the next right of the opponent's connection.
(defrule connect-defense-x-3-blocks-dx 
	(declare (salience ?*move-high-priority*))
	(connect-3-x (begin ?start) (end ?finish) (y ?y) (def-sx ?defense-sx) (def-dx ?defense-dx))
	(possible-move ?defense-dx ?y)
	=> 
	(assert (next-move (move ?defense-dx)))
)

;;Rule that will stop the opponent's alignement of three blocks on the x axis by placing  
;;a block on the next left of the opponent's connection.
(defrule connect-defense-x-3-sx 
	(declare (salience ?*move-high-priority*))
	(connect-3-x (begin ?start) (end ?finish) (y ?y) (def-sx ?defense-sx) (def-dx ?defense-dx))
	(possible-move ?defense-sx ?y)
	=> 
	(assert (next-move (move ?defense-sx)))
)


;;________________________________________Y AXIS_____________________________________

;;Rule that will stop the opponent's alignement of two blocks on the y axis by placing  
;;a block on top of the opponent's connection.
(defrule connect-defense-y-2-top 
	(connect-2-y (begin ?start) (end ?finish) (x ?x) (def-top ?defense-top))
	(possible-move ?x ?defense-top)
	=> 
	(assert (next-move (move ?x)))
)


;;Rule that will stop the opponent's alignement of three blocks on the y axis by placing  
;;a block on top of the opponent's connection.
(defrule connect-defense-y-3-blocks-top 
	(declare (salience ?*move-high-priority*))
	(connect-3-y (begin ?start) (end ?finish) (x ?x) (def-top ?defense-top) )
	(possible-move ?x ?defense-top)
	=> 
	(assert (next-move (move ?x)))
)



;;____________________________________RIGHT DIAGONAL______________________________________

;;Rule that will stop the opponent's alignement of two blocks on the right diagonal by placing  
;;a block on right of the opponent's connection.
(defrule connect-defense-diagdx-2-dx 
	(connect-2-diagdx (begin-x ?x) (begin-y ?y)  
					  (end-x ?x1) (end-y ?y1) 
					  (def-sx-x ?def-sx-x) (def-sx-y ?def-sx-y) 
					  (def-dx-x ?def-dx-x) (def-dx-y ?def-dx-y) 
	)
	(possible-move ?def-dx-x ?def-dx-y)
	=> 
	(assert (next-move (move ?def-dx-x)))
)

;;Rule that will stop the opponent's alignement of two blocks on the right diagonal by placing  
;;a block on left of the opponent's connection.
(defrule connect-defense-diagdx-2-sx 
	(connect-2-diagdx (begin-x ?x) (begin-y ?y)  
					  (end-x ?x1) (end-y ?y1) 
					  (def-sx-x ?def-sx-x) (def-sx-y ?def-sx-y) 
					  (def-dx-x ?def-dx-x) (def-dx-y ?def-dx-y) 
	)
	(possible-move ?def-sx-x ?def-sx-y)
	=> 
	(assert (next-move (move ?def-sx-x)))
)


;;Rule that will stop the opponent's alignement of three blocks on the left diagonal by placing  
;;a block on right of the opponent's connection.
(defrule connect-defense-diagdx-3-dx 
	(declare (salience ?*move-high-priority*))
	(connect-3-diagdx (begin-x ?x) (begin-y ?y)  
					  (end-x ?x1) (end-y ?y1) 
					  (def-sx-x ?def-sx-x) (def-sx-y ?def-sx-y) 
					  (def-dx-x ?def-dx-x) (def-dx-y ?def-dx-y) 
	)
	(possible-move ?def-dx-x ?def-dx-y)
	=> 
	(assert (next-move (move ?def-dx-x)))
)

;;Rule that will stop the opponent's alignement of three blocks on the left diagonal by placing  
;;a block on left of the opponent's connection.
(defrule connect-defense-diagdx-3-sx 
	(declare (salience ?*move-high-priority*))
	(connect-3-diagdx (begin-x ?x) (begin-y ?y)  
					  (end-x ?x1) (end-y ?y1) 
					  (def-sx-x ?def-sx-x) (def-sx-y ?def-sx-y) 
					  (def-dx-x ?def-dx-x) (def-dx-y ?def-dx-y) 
	)
	(possible-move ?def-sx-x ?def-sx-y)
	=> 
	(assert (next-move (move ?def-sx-x)))
)


;;_____________________________________LEFT DIAGONAL______________________________________

;;Rule that will stop the opponent's alignement of two blocks on the left diagonal by placing  
;;a block on right of the opponent's connection.
(defrule connect-defense-diagsx-2-dx 
	(connect-2-diagsx (begin-x ?x) (begin-y ?y)  
					  (end-x ?x1) (end-y ?y1) 
					  (def-sx-x ?def-sx-x) (def-sx-y ?def-sx-y) 
					  (def-dx-x ?def-dx-x) (def-dx-y ?def-dx-y) 
	)
	(possible-move ?def-dx-x ?def-dx-y)
	=> 
	(assert (next-move (move ?def-dx-x)))
)

;;Rule that will stop the opponent's alignement of two blocks on the left diagonal by placing  
;;a block on left of the opponent's connection.
(defrule connect-defense-diagsx-2-sx 
	(connect-2-diagsx (begin-x ?x) (begin-y ?y)  
					  (end-x ?x1) (end-y ?y1) 
					  (def-sx-x ?def-sx-x) (def-sx-y ?def-sx-y) 
					  (def-dx-x ?def-dx-x) (def-dx-y ?def-dx-y) 
	)
	(possible-move ?def-sx-x ?def-sx-y)
	=> 
	(assert (next-move (move ?def-sx-x)))
)



;;Rule that will stop the opponent's alignement of three blocks on the left diagonal by placing  
;;a block on rigth of the opponent's connection.
(defrule connect-defense-diagsx-3-dx 
	(declare (salience ?*move-high-priority*))
	(connect-3-diagsx (begin-x ?x) (begin-y ?y)  
					  (end-x ?x1) (end-y ?y1) 
					  (def-sx-x ?def-sx-x) (def-sx-y ?def-sx-y) 
					  (def-dx-x ?def-dx-x) (def-dx-y ?def-dx-y) 
	)
	(possible-move ?def-dx-x ?def-dx-y)
	=> 
	(assert (next-move (move ?def-dx-x)))
)

;;Rule that will stop the opponent's alignement of three blocks on the left diagonal by placing  
;;a block on left of the opponent's connection.
(defrule connect-defense-diagsx-3-sx 
	(declare (salience ?*move-high-priority*))
	(connect-3-diagsx (begin-x ?x) (begin-y ?y)  
					  (end-x ?x1) (end-y ?y1) 
					  (def-sx-x ?def-sx-x) (def-sx-y ?def-sx-y) 
					  (def-dx-x ?def-dx-x) (def-dx-y ?def-dx-y) 
	)
	(possible-move ?def-sx-x ?def-sx-y)
	=> 
	(assert (next-move (move ?def-sx-x)))
)


;; ___________________________________________________________________________________
;;|																					  |
;;|							 (END)RULES FOR BASIC DEFENSE  							  |
;;|___________________________________________________________________________________|
