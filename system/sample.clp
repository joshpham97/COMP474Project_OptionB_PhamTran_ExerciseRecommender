(deftemplate service
0 10 points
((poor (Z 0 4)) ; Z-Shaped: True at 0, False by 4
(good (PI 2 5)) ; Pi-Shaped: Centered at 5, Width of 2
(excellent (S 6 9)))) ; S-Shaped: False at 6, True by 9

(deftemplate food
0 10 points
((rancid (Z 0 3))
(delicious (S 7 10))))

(deftemplate tip
   0 25 percent
   ((cheap    (0 0) (5 1) (10 0))     
    (average  (10 0) (15 1) (20 0))   
    (generous (20 0) (22.5 1) (25 0))  
   )
)

(defrule rule-poor-service
(service poor)
=>
(assert (tip cheap)))

(defrule rule-good-service
(service good)
=>
(assert (tip average)))

(defrule rule-excellent-service-or-delicious-food
(or (service excellent)
(food delicious))
=>
(assert (tip generous)))

(defrule provide-input
=>
(assert (service (8.2 1.0)))
(assert (food (4.0 1.0))))
; Calculate Final Tip
(defrule calculate-final-tip
(declare (salience -10)) ; This is to ensure it runs last.
?t <- (tip ?)
=>
(bind ?value (moment-defuzzify ?t))
(printout t "The tip is: " ?value "%" crlf))