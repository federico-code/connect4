;; ___________________________________________________________________________________
;;|																					  |
;;|								RULES FOR BASIC ATTACK    							  |
;;|___________________________________________________________________________________|
;;#####################################################################################
;;
;;#####################################################################################


;;________________________________________X AXIS_____________________________________

;;Rule that will stop the opponent's alignement of two blocks on the x axis by placing  
;;a block on the next right of the opponent's connection.
(defrule connect-attack-x-2-blocks-dx 
	(cpu_turn ?player)
	(connect-2-x (player ?player)(begin ?start) (end ?finish) (y ?y) (next-dx ?attack-dx) (next-sx ?attack-sx))
	(possible-move ?attack-dx ?y)
	=> 
	(assert (next-move (move ?attack-dx)))
)

;;Rule that will stop the opponent's alignement of two blocks on the x axis by placing  
;;a block on the next left of the opponent's connection.
(defrule connect-attack-x-2-sx 
	(cpu_turn ?player)
	(connect-2-x (player ?player)(begin ?start) (end ?finish) (y ?y) (next-dx ?attack-dx) (next-sx ?attack-sx))
	(possible-move ?attack-sx ?y)
	=> 
	(assert (next-move (move ?attack-sx)))
)

;;Rule that will stop the opponent's alignement of three blocks on the x axis by placing  
;;a block on the next right of the opponent's connection.
(defrule connect-attack-x-3-blocks-dx 
	(declare (salience ?*move-high-priority*))
	(cpu_turn ?player)
	(connect-3-x (player ?player)(begin ?start) (end ?finish) (y ?y) (next-sx ?attack-sx) (next-dx ?attack-dx))
	(possible-move ?attack-dx ?y)
	=> 
	(assert (next-move (move ?attack-dx)))
)

;;Rule that will stop the opponent's alignement of three blocks on the x axis by placing  
;;a block on the next left of the opponent's connection.
(defrule connect-attack-x-3-sx 
	(declare (salience ?*move-high-priority*))
	(cpu_turn ?player)
	(connect-3-x (player ?player)(begin ?start) (end ?finish) (y ?y) (next-sx ?attack-sx) (next-dx ?attack-dx))
	(possible-move ?attack-sx ?y)
	=> 
	(assert (next-move (move ?attack-sx)))
)

;;________________________________________Y AXIS_____________________________________

;;Rule that will stop the opponent's alignement of two blocks on the y axis by placing  
;;a block on top of the opponent's connection.
(defrule connect-attack-y-2-top
	(cpu_turn ?player) 
	(connect-2-y (player ?player)(begin ?start) (end ?finish) (x ?x) (next-top ?attack-top))
	(possible-move ?x ?attack-top)
	=> 
	(assert (next-move (move ?x)))
)


;;Rule that will stop the opponent's alignement of three blocks on the y axis by placing  
;;a block on top of the opponent's connection.
(defrule connect-attack-y-3-blocks-top 
	(declare (salience ?*move-high-priority*))
	(cpu_turn ?player)
	(connect-3-y (player ?player)(begin ?start) (end ?finish) (x ?x) (next-top ?attack-top) )
	(possible-move ?x ?attack-top)
	=> 
	(assert (next-move (move ?x)))
)

;;____________________________________RIGHT DIAGONAL______________________________________

;;Rule that will stop the opponent's alignement of two blocks on the right diagonal by placing  
;;a block on right of the opponent's connection.
(defrule connect-attack-diagdx-2-dx 
	(cpu_turn ?player)
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
(defrule connect-attack-diagdx-2-sx 
	(cpu_turn ?player)
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
(defrule connect-attack-diagdx-3-dx 
	(declare (salience ?*move-high-priority*))
	(cpu_turn ?player)
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
(defrule connect-attack-diagdx-3-sx 
	(declare (salience ?*move-high-priority*))
	(cpu_turn ?player)
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
(defrule connect-attack-diagsx-2-dx 
	(cpu_turn ?player)
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
(defrule connect-attack-diagsx-2-sx 
	(cpu_turn ?player)
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
(defrule connect-attack-diagsx-3-dx 
	(declare (salience ?*move-high-priority*))
	(cpu_turn ?player)
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
(defrule connect-attack-diagsx-3-sx 
	(declare (salience ?*move-high-priority*))
	(cpu_turn ?player)
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
;;|							 (END)RULES FOR BASIC ATTACK  							  |
;;|___________________________________________________________________________________|
