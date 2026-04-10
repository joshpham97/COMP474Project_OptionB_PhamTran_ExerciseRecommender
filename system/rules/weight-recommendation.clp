; Start assessing fitness level by focus to FITNESS-LEVEL module first

; Calculate recommended weight for each exercise based on user input and fitness level, and assign it to the exercise slot
(deffunction calculate-weight-for-type (?exercise ?modifier-type)
   (bind ?weight 0)
   (bind ?gender "")
   (bind ?modifier 1.0)
   (bind ?fitness-adjustment 1.0)

    ; Get user weight and gender
   (do-for-fact ((?ui user-input)) TRUE
      (bind ?weight (fact-slot-value ?ui weight))
      (bind ?gender (fact-slot-value ?ui gender))
   )
    ; Get exercise modifier based on type
   (do-for-fact ((?em exercise-modifier))
      (and (eq (fact-slot-value ?em name) ?modifier-type)
           (eq (fact-slot-value ?em gender) ?gender))
      (bind ?modifier (fact-slot-value ?em modifier))
   )
    ; Get fitness level adjustment calculated beforehand
   (do-for-fact ((?fla fitness-level-adjustment)) TRUE
        (bind ?fitness-adjustment (/ (fact-slot-value ?fla value) 100.0)); Convert to percentage
    )
    ; Recommended Weight = Exercise_Gender_Modifier × Fitness_Level × BW
   (bind ?recommended-weight (* ?weight ?modifier ?fitness-adjustment))

   (return ?recommended-weight)
)

; Identify exercise type
(deffunction calculate-weight (?exercise)
   (bind ?type nil)

    ; Find which type the exercise belongs to (bench, squat, deadlift)
   (do-for-fact ((?et exercise-type))
      (eq (fact-slot-value ?et name) ?exercise)
      (bind ?type (fact-slot-value ?et type))
   )

   (if (eq ?type nil)
      then
      (return 0) ; return 0 if exercise don't use weight
   else
      (return (calculate-weight-for-type ?exercise ?type))
   )
)

; Go through all exercises and assign recommended weight based on the formula and user input
(defrule assign-recommended-weight
   (declare (salience -10)) ; Run late after all exercise details are assigned
   ?e <- (exercise-slot (exercise ?exercise) (recommended-weight -1)) ;Default value is -1 for the recommended-weight slot, and return value is 0 for non weight
   =>
   (bind ?recommended-weight (calculate-weight ?exercise))
   (modify ?e (recommended-weight ?recommended-weight))
)