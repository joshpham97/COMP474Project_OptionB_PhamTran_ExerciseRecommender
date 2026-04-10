(deffunction assess-weigth-recommendation ()
    (focus FITNESS-LEVEL)
    (run)
    (focus MAIN)
)

(deffunction print-exercise (?i ?e)
    (printout t
                "Order: " ?i
                " | Exercise: " (fact-slot-value ?e exercise)
                " | " (fact-slot-value ?e sets) " sets"
                " x " (fact-slot-value ?e min-reps) "~" (fact-slot-value ?e max-reps) " reps"
                )
    (if (> (fact-slot-value ?e recommended-weight) 0)
        then
        (printout t "| Recommended weight: " (format nil "%.2f" (fact-slot-value ?e recommended-weight)) " kg")
    )
    (printout t crlf) ; Go down to the next line after printing exercise details
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
        (printout t "  injuries can happen to anyone, especially those new to strength training. Follow the program" crlf)
        (printout t "  progressively, prioritize form over weight, and listen to your body." crlf crlf))
    (focus MAIN)
)


(deffunction print-weight-reccomendation-explanation ()
    
    (printout t crlf "=== Weight Recommendation Assessment ===" crlf)
    
   ; Bindings
   (bind ?height 0)
   (bind ?weight 0)
   (bind ?gender "")
   (bind ?bmi-score 0)
   (bind ?bmi-label "")
   (bind ?activity-label "")
   (bind ?fitness-label "")

    ; Get user height, weight and gender
    (do-for-fact ((?ui user-input)) TRUE
        (bind ?height (fact-slot-value ?ui height))
        (bind ?weight (fact-slot-value ?ui weight))
        (bind ?gender (fact-slot-value ?ui gender))
    )
       ; Get BMI defuzzified value and label
    (do-for-fact ((?b bmi)) TRUE
        (bind ?bmi-score (moment-defuzzify ?b))
        (bind ?bmi-label
            (if (< ?bmi-score 18.5) then "underweight"
            else (if (<= ?bmi-score 24.9) then "normal"
            else "overweight"))
        )
    )

    ; Get activity level defuzzified value and label
   (do-for-fact ((?al activity-level)) TRUE
        (bind ?activity-score (maximum-defuzzify ?al))
        (bind ?activity-label
            (if (< ?activity-score 150) then "sedentary"
            else (if (< ?activity-score 300) then "moderate"
            else "active"))
        )
   )

   ; Get fitness level defuzzified value and label
    (do-for-fact ((?fl fitness-level)) TRUE
        (bind ?fitness-score (moment-defuzzify ?fl))
        (printout t "Debug: Fitness score is " ?fitness-score crlf) ; Debug print
        (bind ?fitness-label
            (if (< ?fitness-score 3.0) then "low"
            else (if (< ?fitness-score 7.0) then "medium"
            else "high")
            )
        )
    )

    ; Print user info
    (printout t "Your height: " ?height " cm" crlf)
    (printout t "Your weight: " ?weight " kg" crlf)
    (printout t "Your BMI is: " (format nil "%.2f" ?bmi-score) crlf)
    
    ; Print BMI explanation
    (if (eq ?bmi-label "normal")
        then (printout t "Based on your BMI, you are classified as normal weight." crlf)
    else (if (eq ?bmi-label "overweight")
        then (printout t "Based on your BMI, you are classified as overweight." crlf)
    else
        (printout t "Based on your BMI, you are classified as underweight." crlf)
    ))

    ; Print activity level explanation
    (printout t crlf "Your activity level is considered: " ?activity-label crlf)
    (if (eq ?activity-label "sedentary")
        then (printout t "You do very little or no exercise per week." crlf)
    else (if (eq ?activity-label "moderate")
        then (printout t "You engage in a good amount of physical activity per week." crlf)
    else
        (printout t "You engage in a lot of physical activity per week." crlf)
    ))

    ; Print fitness level explanation
    (printout t crlf "Your fitness level is: " ?fitness-label crlf)
    (if (eq ?fitness-label "low")
        then (printout t "You should start with a conservative weight to build strength and reduce injury risk." crlf)
    else (if (eq ?fitness-label "medium")
        then (printout t "You can start with a moderate weight that balances challenge and safety." crlf)
    else
        (printout t "You can start with a more aggressive weight to maximize strength gains." crlf)
    ))
)


(deffunction output ()
    (assess-weigth-recommendation)
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
    (print-weight-reccomendation-explanation)
)