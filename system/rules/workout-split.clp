(defrule assign-full-body
   (user-input (frequency ?f&:(and (neq ?f nil) (= ?f 3))))
   =>
   (assert (workout-split 
            (name "Full-body"))))

(defrule assign-upper-lower
   (user-input (frequency ?f&:(and (neq ?f nil) (= ?f 4))))
   (not  (workout-split))
   =>
   (assert (workout-split (name "Upper-Lower")))
   (focus UPPER-LOWER)
)

(defrule assign-push-pull-leg
   (user-input (frequency ?f&:(and (neq ?f nil) (= ?f 6))))
   =>
   (assert (workout-split 
            (name "Push-Pull-Leg"))))

(defrule activate-split
   (workout-split (name ?name))
   =>
   (if (eq ?name "Full-body") then (focus FULL-BODY))
   (if (eq ?name "Upper-Lower") then (focus UPPER-LOWER))
   (if (eq ?name "Push-Pull-Leg") then (focus PUSH-PULL-LEG))
)

; Reps determination

(defrule assign-rep-strength
   (user-input (goal strength))
   ?e <- (exercise-slot (min-reps ?r&~1) (max-reps ?r&~5))
   =>
   (modify ?e (min-reps 1) (max-reps 5)))

(defrule assign-rep-hypertrophy
   (user-input (goal hypertrophy))
   ?e <- (exercise-slot (min-reps ?r&~8) (max-reps ?r&~12))
   =>
   (modify ?e (min-reps 8) (max-reps 12)))
(defrule assign-rep-endurance
   (user-input (goal endurance))
   ?e <- (exercise-slot (min-reps ?r&~15) (max-reps ?r&~100))
   =>
   (modify ?e (min-reps 15) (max-reps 100)))

; Set assignment
(defrule assign-set-high-priority
   ?e <- (exercise-slot (primary-muscle-group ?m) (sets 0))
   (muscle-group (name ?m) (priority 1))
   =>
   (modify ?e (sets 3)))
(defrule assign-set-not-high-priority
   ?e <- (exercise-slot (primary-muscle-group ?m) (sets 0))
   (muscle-group (name ?m) (priority ?p&~1))
   =>
   (modify ?e (sets 2))) 

(defrule compute-global-order
   ?s <- (exercise-slot (day-order ?day-order) (exercise-order ?exercise-order) (global-order nil))
   =>
   (modify ?s (global-order (+ (* ?day-order 100) ?exercise-order)))
)

