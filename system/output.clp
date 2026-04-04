
(deffunction print-exercise (?i ?e)
    (printout t
                "Order: " ?i
                " | Exercise: " (fact-slot-value ?e exercise)
                " | " (fact-slot-value ?e sets) " sets"
                " x " (fact-slot-value ?e min-reps) "~" (fact-slot-value ?e max-reps) " reps"
                crlf)
    )

(deffunction print-plan (?name ?day-order)
   (printout t crlf "=== "?name" ===" crlf)
   (loop-for-count (?i 1 10)
      (bind ?matches (find-fact ((?e exercise-slot))
            (and
                (eq (fact-slot-value ?e day-order) ?day-order)
                (eq (fact-slot-value ?e exercise-order) ?i)
            )))
      (if (> (length$ ?matches) 0)
         then
         (print-exercise ?i (nth$ 1 ?matches)))
   )
   (printout t crlf)
)

; Full-body
(deffunction print-full-body-plan ()
    (print-plan "Day 1" 1)
    (print-plan "Day 2" 2)
    (print-plan "Day 3" 3)
)

; Upper-Lower
(deffunction print-upper-lower ()
   (print-plan "Upper 1" 1)
   (print-plan "Lower 1" 2)
   (print-plan "Upper 2" 3)
   (print-plan "Lower 2" 4)
)

(deffunction print-push-pull-leg ()
    (print-plan "Push 1" 1)
    (print-plan "Pull 1" 2)
    (print-plan "Leg 1" 3)
    (bind ?ui (nth$ 1 (find-fact ((?f user-input)) TRUE)))
    (if (= (fact-slot-value ?ui frequency) 6)
        then
        (print-plan "Push 2" 4)
        (print-plan "Pull 2" 5)
        (print-plan "Leg 2" 6))
)

; Claude AI (4/3) - Prompt: Add code to the assess-injury-risk function to print out the recommendations
(deffunction assess-injury-risk ()
    (focus INJURY-PREDICTION)
    (run)
    (bind ?recs (find-all-facts ((?r recommendation)) TRUE))
    (if (> (length$ ?recs) 0)
      then
        (printout t crlf "=== Injury Risk Recommendations ===" crlf)
        (progn$ (?r ?recs)
            (printout t "  [" (fact-slot-value ?r reason) "] " (fact-slot-value ?r description) crlf))
        (bind ?explanations (fact-slot-value (nth$ 1 (find-all-facts ((?e injury-explanation)) TRUE)) explanations))
        (if (> (length$ ?explanations) 0)
          then
            (printout t crlf "  Reasons:" crlf)
            (progn$ (?exp ?explanations)
                (printout t "    - " ?exp crlf)))
        (printout t crlf)
      else
        (printout t crlf "=== Injury Risk Assessment ===" crlf)
        (printout t "  No elevated injury risk was detected based on your profile. That said, even with a clean history," crlf)
        (printout t "  injuries can happen to anyone — especially those new to strength training. Follow the program" crlf)
        (printout t "  progressively, prioritize form over weight, and listen to your body." crlf crlf))
    (focus MAIN)
)

(deffunction output ()
    (run)
    (bind ?ws (nth$ 1 (find-fact ((?f workout-split)) TRUE)))
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
    (assess-injury-risk)
)