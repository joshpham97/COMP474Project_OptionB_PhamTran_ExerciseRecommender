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
   (user-input (goal hypertrophy))
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

(defrule assign-next-exercise
   (declare (salience -1))
   ;; Match a day
   ?day <- (day (name ?dname))
   
   ;; Find the last assigned exercise for this day (highest order)
   ?last <- (exercise-slot (day ?dname) (order ?last-order&~nil) (priority ?last-priority&~nil) (primary-muscle-group ?last-mg))
   (not (exercise-slot (day ?dname) (order ?o2&~nil&:(> ?o2 ?last-order))))
   
   ;; Find an unassigned exercise for this day
   ?unassigned-slot <- (exercise-slot (day ?dname) (order nil) (primary-muscle-group ?unassigned-mg) (priority ?unassigned-priority&~nil))
   
   ;; Ensure it is not the same muscle group as the last assigned exercise
   (test (or (eq ?last nil) (neq ?unassigned-mg ?last-mg)))

   ;; Ensure there is no unassigned exercise with higher priority
   (not (exercise-slot (day ?dname) (order nil) (priority ?p2&~nil&:(> ?unassigned-priority ?p2))))

   =>
   ;; Compute next order number
   (bind ?next-order (+ ?last-order 1))
   
   ;; Assign the exercise
   (modify ?unassigned-slot (order ?next-order))
)