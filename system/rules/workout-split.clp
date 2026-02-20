(defrule assign-full-body
   (user-input (frequency ?f&:(and (neq ?f nil) (= ?f 3))))
   =>
   (assert (workout-split 
            (name "Full-body"))))

(defrule assign-upper-lower
   (user-input (frequency ?f&:(and (neq ?f nil) (= ?f 4))))
   =>
   (assert (workout-split 
            (name "Upper-Lower"))))

(defrule assign-push-pull-leg
   (user-input (frequency ?f&:(and (neq ?f nil) (= ?f 6))))
   =>
   (assert (workout-split 
            (name "Push-Pull-Leg"))))


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

(defrule assign-next-order
   (declare (salience -1))
   ?day <- (day (name ?dname))
   ?last <- (exercise-slot (day ?dname) (order ?last-order&~nil) (priority ?last-priority&~nil) (primary-muscle-group ?last-mg))
   (not (exercise-slot (day ?dname) (order ?o2&~nil&:(> ?o2 ?last-order))))
   ?unassigned-slot <- (exercise-slot (day ?dname) (order nil) (primary-muscle-group ?unassigned-mg) (priority ?unassigned-priority&~nil))
   (test (or (eq ?last nil) (neq ?unassigned-mg ?last-mg)))
   (not (exercise-slot (day ?dname) (order nil) (priority ?p2&~nil&:(> ?unassigned-priority ?p2))))

   =>
   ;; Compute next order number
   (bind ?next-order (+ ?last-order 1))
   
   ;; Assign the exercise
   (modify ?unassigned-slot (order ?next-order))
)

(defrule assign-first-exercise-by-weakpoint
   (day (name ?dname) (focus ?f))
   (user-input (muscle-group ?mg))
   ?mg-fact <- (muscle-group (name ?mg) (region ?f))
   (not (exercise-slot (day ?dname) (order 1)))
   ?exercise <- (exercise-slot (day ?dname) (primary-muscle-group ?mg) (priority ?p&~nil) (order nil))
   =>
   (modify ?exercise (order 1))
)

(defrule initialize-priority
   ?exercise <- (exercise-slot (primary-muscle-group ?mg) (priority nil))
   ?muscle-group <- (muscle-group (name ?mg) (priority ?p))
   =>
   (modify ?exercise (priority ?p))
)
