(defrule assign-full-body
   (user-input (frequency ?f&:(and (neq ?f nil) (= ?f 3))))
   =>
   (assert (workout-split 
            (name "Full-body"))))

(defrule assign-upper-lower
   (user-input (frequency ?f&:(and (neq ?f nil) (or (= ?f 4) (= ?f 5)))))
   =>
   (assert (workout-split 
            (name "Upper-Lower"))))

(defrule assign-push-pull-leg
   (user-input (frequency ?f&:(and (neq ?f nil) (= ?f 6))))
   =>
   (assert (workout-split 
            (name "Push-Pull-Leg"))))