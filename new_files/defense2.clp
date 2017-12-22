
;; ___________________________________________________________________________________
;;|																					  |
;;|								RULES FOR MEDIUM DEFENS    							  |
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
	(dim (x ?dimx)(y $?))
	(player_turn ?player)
	(connect-2-x (player ?player)(begin ?start) (end ?finish) (y ?y) (next-dx ?defense-dx) (next-sx ?defense-sx))
	(possible-move ?defense-dx ?y)	
	(test (neq ?dimx ?defense-dx))
	=> 
	(assert (next-move (move ?defense-dx)))
)

;;Rule that will stop the opponent's alignement of two blocks on the x axis by placing  
;;a block on the next left of the opponent's connection.
(defrule connect-defense-x-2-sx 
	(player_turn ?player)
	(connect-2-x (player ?player)(begin ?start) (end ?finish) (y ?y) (next-dx ?defense-dx) (next-sx ?defense-sx))
	(possible-move ?defense-sx ?y)
	(test (neq ?defense-sx 0))
	=> 
	(assert (next-move (move ?defense-sx)))
)

;;Rule that will stop the opponent's alignement of three blocks on the x axis by placing  
;;a block on the next right of the opponent's connection.
(defrule connect-defense-x-3-blocks-dx 
	(declare (salience ?*move-middle-priority*))
	(player_turn ?player)
	(connect-3-x (player ?player)(begin ?start) (end ?finish) (y ?y) (next-sx ?defense-sx) (next-dx ?defense-dx))
	(possible-move ?defense-dx ?y)
	=> 
	(assert (next-move (move ?defense-dx)))
)

;;Rule that will stop the opponent's alignement of three blocks on the x axis by placing  
;;a block on the next left of the opponent's connection.
(defrule connect-defense-x-3-sx 
	(declare (salience ?*move-middle-priority*))
	(player_turn ?player)
	(connect-3-x (player ?player)(begin ?start) (end ?finish) (y ?y) (next-sx ?defense-sx) (next-dx ?defense-dx))
	(possible-move ?defense-sx ?y)
	=> 
	(assert (next-move (move ?defense-sx)))
)


;;________________________________________Y AXIS_____________________________________

;;Rule that will stop the opponent's alignement of two blocks on the y axis by placing  
;;a block on top of the opponent's connection.
(defrule connect-defense-y-2-top
	(player_turn ?player) 
	(connect-2-y (player ?player)(begin ?start) (end ?finish) (x ?x) (next-top ?defense-top))
	(possible-move ?x ?defense-top)
	(test (neq ?defense-top 0))
	=> 
	(assert (next-move (move ?x)))
)


;;Rule that will stop the opponent's alignement of three blocks on the y axis by placing  
;;a block on top of the opponent's connection.
(defrule connect-defense-y-3-blocks-top 
	(declare (salience ?*move-middle-priority*))
	(player_turn ?player)
	(connect-3-y (player ?player)(begin ?start) (end ?finish) (x ?x) (next-top ?defense-top) )
	(possible-move ?x ?defense-top)
	=> 
	(assert (next-move (move ?x)))
)



;;____________________________________RIGHT DIAGONAL______________________________________

;;Rule that will stop the opponent's alignement of two blocks on the right diagonal by placing  
;;a block on right of the opponent's connection.
(defrule connect-defense-diagdx-2-dx 
	(player_turn ?player)
	(connect-2-diagdx (player ?player)
						(begin-x ?x) (begin-y ?y)  
					  (end-x ?x1) (end-y ?y1) 
					  (next-sx-x ?next-sx-x) (next-sx-y ?next-sx-y) 
					  (next-dx-x ?next-dx-x) (next-dx-y ?next-dx-y) 
	)
	(possible-move ?next-dx-x ?next-dx-y)
	=> 
	(assert (next-move (move ?next-dx-x)))
)

;;Rule that will stop the opponent's alignement of two blocks on the right diagonal by placing  
;;a block on left of the opponent's connection.
(defrule connect-defense-diagdx-2-sx 
	(player_turn ?player)
	(connect-2-diagdx (player ?player)
						(begin-x ?x) (begin-y ?y)  
					  (end-x ?x1) (end-y ?y1) 
					  (next-sx-x ?next-sx-x) (next-sx-y ?next-sx-y) 
					  (next-dx-x ?next-dx-x) (next-dx-y ?next-dx-y) 
	)
	(possible-move ?next-sx-x ?next-sx-y)
	=> 
	(assert (next-move (move ?next-sx-x)))
)


;;Rule that will stop the opponent's alignement of three blocks on the left diagonal by placing  
;;a block on right of the opponent's connection.
(defrule connect-defense-diagdx-3-dx 
	(declare (salience ?*move-middle-priority*))
	(player_turn ?player)
	(connect-3-diagdx (player ?player)
						(begin-x ?x) (begin-y ?y)  
					  (end-x ?x1) (end-y ?y1) 
					  (next-sx-x ?next-sx-x) (next-sx-y ?next-sx-y) 
					  (next-dx-x ?next-dx-x) (next-dx-y ?next-dx-y) 
	)
	(possible-move ?next-dx-x ?next-dx-y)
	=> 
	(assert (next-move (move ?next-dx-x)))
)

;;Rule that will stop the opponent's alignement of three blocks on the left diagonal by placing  
;;a block on left of the opponent's connection.
(defrule connect-defense-diagdx-3-sx 
	(declare (salience ?*move-middle-priority*))
	(player_turn ?player)
	(connect-3-diagdx (player ?player)
						(begin-x ?x) (begin-y ?y)  
					  (end-x ?x1) (end-y ?y1) 
					  (next-sx-x ?next-sx-x) (next-sx-y ?next-sx-y) 
					  (next-dx-x ?next-dx-x) (next-dx-y ?next-dx-y) 
	)
	(possible-move ?next-sx-x ?next-sx-y)
	=> 
	(assert (next-move (move ?next-sx-x)))
)


;;_____________________________________LEFT DIAGONAL______________________________________

;;Rule that will stop the opponent's alignement of two blocks on the left diagonal by placing  
;;a block on right of the opponent's connection.
(defrule connect-defense-diagsx-2-dx 
	(player_turn ?player)
	(connect-2-diagsx (player ?player)
						(begin-x ?x) (begin-y ?y)  
					  (end-x ?x1) (end-y ?y1) 
					  (next-sx-x ?next-sx-x) (next-sx-y ?next-sx-y) 
					  (next-dx-x ?next-dx-x) (next-dx-y ?next-dx-y) 
	)
	(possible-move ?next-dx-x ?next-dx-y)
	=> 
	(assert (next-move (move ?next-dx-x)))
)

;;Rule that will stop the opponent's alignement of two blocks on the left diagonal by placing  
;;a block on left of the opponent's connection.
(defrule connect-defense-diagsx-2-sx 
	(player_turn ?player)
	(connect-2-diagsx (player ?player)
						(begin-x ?x) (begin-y ?y)  
					  (end-x ?x1) (end-y ?y1) 
					  (next-sx-x ?next-sx-x) (next-sx-y ?next-sx-y) 
					  (next-dx-x ?next-dx-x) (next-dx-y ?next-dx-y) 
	)
	(possible-move ?next-sx-x ?next-sx-y)
	=> 
	(assert (next-move (move ?next-sx-x)))
)



;;Rule that will stop the opponent's alignement of three blocks on the left diagonal by placing  
;;a block on rigth of the opponent's connection.
(defrule connect-defense-diagsx-3-dx 
	(declare (salience ?*move-middle-priority*))
	(player_turn ?player)
	(connect-3-diagsx (player ?player)
						(begin-x ?x) (begin-y ?y)  
					  (end-x ?x1) (end-y ?y1) 
					  (next-sx-x ?next-sx-x) (next-sx-y ?next-sx-y) 
					  (next-dx-x ?next-dx-x) (next-dx-y ?next-dx-y) 
	)
	(possible-move ?next-dx-x ?next-dx-y)
	=> 
	(assert (next-move (move ?next-dx-x)))
)

;;Rule that will stop the opponent's alignement of three blocks on the left diagonal by placing  
;;a block on left of the opponent's connection.
(defrule connect-defense-diagsx-3-sx 
	(declare (salience ?*move-middle-priority*))
	(player_turn ?player)
	(connect-3-diagsx (player ?player)
						(begin-x ?x) (begin-y ?y)  
					  (end-x ?x1) (end-y ?y1) 
					  (next-sx-x ?next-sx-x) (next-sx-y ?next-sx-y) 
					  (next-dx-x ?next-dx-x) (next-dx-y ?next-dx-y) 
	)
	(possible-move ?next-sx-x ?next-sx-y)
	=> 
	(assert (next-move (move ?next-sx-x)))
)


;; ___________________________________________________________________________________
;;|																					  |
;;|							 (END)RULES FOR BASIC DEFENSE  							  |
;;|___________________________________________________________________________________|
