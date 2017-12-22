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


(deftemplate connect-4-x-hole
  (slot player (type INTEGER)(default ?NONE))
  (slot begin (type INTEGER) (default ?NONE))
  (slot end (type INTEGER) (default ?NONE))
  (slot y (type INTEGER) (default ?NONE))
  (slot hole-x (type INTEGER) (default ?NONE))
  (slot hole-y (type INTEGER) (default ?NONE))
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




(deftemplate connect-4-diagdx-hole
  (slot player (type INTEGER)(default ?NONE))
  (slot begin-x (type INTEGER) (default ?NONE)) 
  (slot begin-y (type INTEGER) (default ?NONE))
  (slot end-x (type INTEGER) (default ?NONE))
  (slot end-y (type INTEGER) (default ?NONE))  
  (slot hole-x (type INTEGER) (default ?NONE))
  (slot hole-y (type INTEGER) (default ?NONE))
)	

(deftemplate connect-4-diagsx-hole
  (slot player (type INTEGER)(default ?NONE))
  (slot begin-x (type INTEGER) (default ?NONE))
  (slot begin-y (type INTEGER) (default ?NONE))
  (slot end-x (type INTEGER) (default ?NONE))
  (slot end-y (type INTEGER) (default ?NONE))  
  (slot hole-x (type INTEGER) (default ?NONE))
  (slot hole-y (type INTEGER) (default ?NONE))
)	


(deftemplate possible-win 
  (slot player (type INTEGER)(default ?NONE))
  (slot x (type INTEGER) (default ?NONE))
  (slot y (type INTEGER) (default ?NONE))
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
;;|				 		 RULES FOR SPOTTING CONNECTIONS OF BLOCKS					  |
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
(defrule connect-x-3-blocks
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



;______RULES OF TYPE: connect-4-[x/diagdx/diagsx]-hole-[dx/sx]______________________
; these rules will spot if there's a possible connect 4 with a blank spot (hole)
; es connect-4-x-hole-blocks-dx
;    player 1: X
;    player 2: O

; 0
; 1
; 2	
; 3		
; 4			
; 5	O 	X 	X  (*)	X	
; 0	1	2	3	4	5	* -> here is a possible connect 4 of the player X by inseting a block in coordinates (4 5)
; 							 the rule 'connect-4-x-hole-blocks-dx' will assert the fact 
;							(connect-4-x-hole (player 1) (begin 2) (end 5) (y 5) (hole-x 4) (hole-y 5) )


;BUGG[[[[tutti I fatti asseriti da queste regole bisognerebbe ritrattarli appena qualcuno mette la pedina in quel posto
;			e non bisognerebbe asserirli se c'e gia una pedina in mezzo]]]]]

(defrule connect-4-x-hole-blocks-dx
	(declare (salience ?*connect-priority*))
	(connect-2-x (player ?player) (begin ?begin) (end ?end) (y ?y) (next-sx $?) (next-dx ?next-dx) )
	(G ?player ?x ?y)
	(test (eq (+ ?next-dx 1) ?x))
	=> 
	(assert (connect-4-x-hole (player ?player) (begin ?begin) (end ?x) (y ?y) (hole-x ?next-dx) (hole-y ?y) ))
)

(defrule connect-4-x-hole-blocks-sx
	(declare (salience ?*connect-priority*))
	(connect-2-x (player ?player) (begin ?begin) (end ?end) (y ?y) (next-sx ?next-sx) (next-dx $?) )
	(G ?player ?x ?y)
	(test (eq (- ?next-sx 1) ?x))
	=> 
	(assert (connect-4-x-hole (player ?player) (begin ?x) (end ?end) (y ?y) (hole-x ?next-sx) (hole-y ?y) ))
)



(defrule connect-4-diagdx-hole-blocks-dx
	(declare (salience ?*connect-priority*))
	(connect-2-diagdx (player ?player)
							(begin-x ?begin-x) (begin-y ?begin-y) 
							(end-x $?) (end-y $?) 
							(next-sx-x $?) (next-sx-y $?) 
							(next-dx-x ?x-dx)(next-dx-y ?y-dx) )	
	(G ?player ?x ?y)
	(test (eq (+ ?x-dx 1) ?x))
	(test (eq (- ?y-dx 1) ?y))
	=> 
	(assert (connect-4-diagdx-hole (player ?player) 
									(begin-x ?begin-x) (begin-y ?begin-y)
									(end-x ?x) (end-y ?y)
									(hole-x ?x-dx) (hole-y ?y-dx) ))
)


(defrule connect-4-diagdx-hole-blocks-sx
	(declare (salience ?*connect-priority*))
	(connect-2-diagdx (player ?player)
							(begin-x ?begin-x) (begin-y ?begin-y) 
							(end-x ?end-x) (end-y ?end-y) 
							(next-sx-x ?x-sx) (next-sx-y ?y-sx) 
							(next-dx-x $?)(next-dx-y $?) )	
	(G ?player ?x ?y)
	(test (eq (- ?x-sx 1) ?x))
	(test (eq (+ ?y-sx 1) ?y))
	=> 
	(assert (connect-4-diagdx-hole (player ?player) 
									(begin-x ?x) (begin-y ?y)
									(end-x ?end-x) (end-y ?end-y)
									(hole-x ?x-sx) (hole-y ?y-sx) ))
)



(defrule connect-4-diagsx-hole-blocks-dx
	(declare (salience ?*connect-priority*))
	(connect-2-diagsx (player ?player)
							(begin-x ?begin-x) (begin-y ?begin-y) 
							(end-x ?end-x) (end-y ?end-y) 
							(next-sx-x $?) (next-sx-y $?) 
							(next-dx-x ?x-dx)(next-dx-y ?y-dx) )	
	(G ?player ?x ?y)
	(test (eq (+ ?x-dx 1) ?x))
	(test (eq (+ ?y-dx 1) ?y))
	=> 
	(assert (connect-4-diagsx-hole (player ?player) 
									(begin-x ?begin-x) (begin-y ?begin-y)
									(end-x ?x) (end-y ?y)
									(hole-x ?x-dx) (hole-y ?y-dx) ))
)


(defrule connect-4-diagsx-hole-blocks-sx
	(declare (salience ?*connect-priority*))
	(connect-2-diagsx (player ?player)
							(begin-x ?begin-x) (begin-y ?begin-y) 
							(end-x ?end-x) (end-y ?end-y) 
							(next-sx-x ?x-sx) (next-sx-y ?y-sx) 
							(next-dx-x $?)(next-dx-y $?) )	
	(G ?player ?x ?y)
	(test (eq (- ?x-sx 1) ?x))
	(test (eq (- ?y-sx 1) ?y))
	=> 
	(assert (connect-4-diagsx-hole (player ?player) 
									(begin-x ?x) (begin-y ?y)
									(end-x ?end-x) (end-y ?end-y)
									(hole-x ?x-sx) (hole-y ?y-sx) ))
)

;; ___________________________________________________________________________________
;;|																					  |
;;|			 (END) RULES FOR SPOTTING CONNECTIONS OF THE OPPONENT BLOCKS			  |
;;|___________________________________________________________________________________|



;; ___________________________________________________________________________________
;;|																					  |
;;|				  RULES FOR SPOTTING POSSIBLE DANGEROUS MOVES (IN FUTURE MOVES) 	  |
;;|___________________________________________________________________________________|
;;#####################################################################################
;;rules that assert the fact possible-win, that indicates a coordinate at which the player 
;;can positionate the block to win and it is not possible at the current state to win 
;;(insert the block at the coordinates)

; es dangerous-connect-x-sx
;    player 1: X
;    player 2: O	

; 0
; 1
; 2(*)	X	X 	X 	O
; 3		O 	O 	O 	O
; 4		O 	O 	O 	O	
; 5		O 	O 	O 	O
; 0	1	2	3	4	5	* -> here is a possible-win of the player X by inseting a block in coordinates (1 2)
; 							 the rule 'dangerous-connect-x-sx' will assert the fact (possible-win (player 1) (x 1) (y 2))
;;#####################################################################################

;BUGGGG[[[[tutti sti fatti (possible-win) bisognerebbe ritrattarli appena qualcuno mette la pedina in quel posto]]]]]

(defrule dangerous-connect-x-sx
	(declare (salience ?*connect-priority*))
	(connect-3-x (player ?player) (begin $?) (end $?) (y ?y) (next-sx ?next-sx) (next-dx $?))
	(not (G $? ?next-sx ?y))
	(not (possible-move ?next-sx ?y))
	(test(>= ?next-sx 0))
	=> 
	(assert (possible-win (player ?player) (x ?next-sx) (y ?y)))
)

(defrule dangerous-connect-x-dx
	(declare (salience ?*connect-priority*))
	(dim (x ?dimx) (y $?))
	(connect-3-x (player ?player) (begin $?) (end $?) (y ?y) (next-sx $?) (next-dx ?next-dx))
	(not (G $? ?next-dx ?y))
	(not (possible-move ?next-dx ?y))
	(test (<= ?next-dx ?dimx))
	=> 
	(assert (possible-win (player ?player) (x ?next-dx) (y ?y)))
)


(defrule dangerous-connect-diagdx-sx
	(declare (salience ?*connect-priority*))
	(dim (x ?dimx) (y ?dimy))
	(connect-3-diagdx (player ?player)
							  (begin-x $?) (begin-y $?)  
							  (end-x $?) (end-y $?) 
							  (next-sx-x ?next-sx-x) (next-sx-y ?next-sx-y) 
							  (next-dx-x ?next-dx-x) (next-dx-y ?next-dx-y) 
	)
	(not (G $? ?next-sx-x ?next-sx-y))
	(not (possible-move ?next-sx-x ?next-sx-y))
	(test (>= ?next-sx-x 0))
	(test (<= ?next-sx-y ?dimy))
	=> 
	(assert (possible-win (player ?player) (x ?next-sx-x) (y ?next-sx-y)))
)

(defrule dangerous-connect-diagdx-dx
	(declare (salience ?*connect-priority*))
	(dim (x ?dimx) (y ?dimy))
	(connect-3-diagdx (player ?player)
							  (begin-x $?) (begin-y $?)  
							  (end-x $?) (end-y $?) 
							  (next-sx-x ?next-sx-x) (next-sx-y ?next-sx-y) 
							  (next-dx-x ?next-dx-x) (next-dx-y ?next-dx-y) 
	)
	(not (G $? ?next-dx-x ?next-dx-y))
	(not (possible-move ?next-dx-x ?next-dx-y))
	(test (<= ?next-sx-x ?dimx))
	(test (>= ?next-sx-y 0))
	=> 
	(assert (possible-win (player ?player) (x ?next-dx-x) (y ?next-dx-y)))
)




(defrule dangerous-connect-diagsx-sx
	(declare (salience ?*connect-priority*))
	(dim (x ?dimx) (y ?dimy))
	(connect-3-diagsx (player ?player)
							  (begin-x $?) (begin-y $?)  
							  (end-x $?) (end-y $?) 
							  (next-sx-x ?next-sx-x) (next-sx-y ?next-sx-y) 
							  (next-dx-x ?next-dx-x) (next-dx-y ?next-dx-y) 
	)
	(not (G $? ?next-dx-x ?next-dx-y))
	(not (possible-move ?next-dx-x ?next-dx-y))
	(test (<= ?next-sx-x ?dimx))
	(test (>= ?next-sx-y 0))
	=> 
	(assert (possible-win (player ?player) (x ?next-sx-x) (y ?next-sx-y)))
)


(defrule dangerous-connect-diagsx-dx
	(declare (salience ?*connect-priority*))
	(dim (x ?dimx) (y ?dimy))
	(connect-3-diagsx (player ?player)
							  (begin-x $?) (begin-y $?)  
							  (end-x $?) (end-y $?) 
							  (next-sx-x ?next-sx-x) (next-sx-y ?next-sx-y) 
							  (next-dx-x ?next-dx-x) (next-dx-y ?next-dx-y) 
	)
	(not (G $? ?next-dx-x ?next-dx-y))
	(not (possible-move ?next-dx-x ?next-dx-y))
	(test (>= ?next-dx-x 0))
	(test (<= ?next-dx-y ?dimy))
	=> 
	(assert (possible-win (player ?player) (x ?next-dx-x) (y ?next-dx-y)))
)
;; ___________________________________________________________________________________
;;|																					  |
;;|			(END)RULES FOR SPOTTING POSSIBLE DANGEROUS MOVES (IN FUTURE MOVES)	 	  |
;;|___________________________________________________________________________________|
