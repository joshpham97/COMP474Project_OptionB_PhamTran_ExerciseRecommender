
(deffunction print-exercise (?i ?e)
    (printout t
                "Order: " ?i
                " | Exercise: " (fact-slot-value ?e exercise)
                " | " (fact-slot-value ?e sets) " sets"
                " x " (fact-slot-value ?e min-reps) "~" (fact-slot-value ?e max-reps) " reps"
                crlf)
    )
(deffunction print-plan (?name)
   (printout t crlf "=== "?name" ===" crlf)
   ;; assume max 10 exercises (adjust if needed)
   (loop-for-count (?i 1 10)

      (do-for-all-facts ((?e exercise-slot))
         (and
            (eq (fact-slot-value ?e day) ?name)
            (eq (fact-slot-value ?e order) ?i))
            (print-exercise ?i ?e)))
   (printout t crlf)
)
; Full-body
(deffunction print-full-body-plan ()
    (print-plan "Day 1")
    (print-plan "Day 2")
    (print-plan "Day 3")
)
; Upper-Lower
(deffunction print-upper-lower ()
   (print-plan "Upper 1")
   (print-plan "Lower 1")
   (print-plan "Upper 2")
   (print-plan "Lower 2")
)

(deffunction print-push-pull-leg ()
    (print-plan "Push 1")
    (print-plan "Pull 1")
    (print-plan "Leg 1")
    (do-for-all-facts ((?u user-input))
        (eq (fact-slot-value ?u frequency) 6)
        => 
        ;; print second round if frequency = 6
        (print-plan "Push 2")
        (print-plan "Pull 2")
        (print-plan "Leg 2")
    )
)
(deffunction output ()
    (run)
    (do-for-all-facts ((?ws workout-split))
        TRUE
        =>

        (bind ?sn (fact-slot-value ?ws name))
        (if (eq ?sn "Full-body")
            then
            (print-full-body-plan)
            else
            (if (eq ?sn "Upper-Lower")
                then
                (print-upper-lower)
                else 
                (if (eq ?sn "Push-Pull-Leg")
                    then
                    (print-push-pull-leg))
            )
        )
    
    )
)