; Test that weight recommendation is assigned correctly for exercises that use weight, and that non-weight exercises have 0 recommended weight
(deffunction test-weight-recommendation-assignment ()
    (bind ?success TRUE)
    (do-for-all-facts ((?e exercise-slot)) TRUE
        (printout t "Exercise: " (fact-slot-value ?e exercise) ", Recommended Weight: " (fact-slot-value ?e recommended-weight) crlf)
        ; Get the exercise name
        (bind ?exercise (fact-slot-value ?e exercise))
        (bind ?type nil)
        (bind ?recommended-weight (fact-slot-value ?e recommended-weight))

        ; Find which type the exercise belongs to (bench, squat, deadlift)
        (do-for-fact ((?et exercise-type))
            (eq (fact-slot-value ?et name) ?exercise)
            (bind ?type (fact-slot-value ?et type))
        )

        (if (not (eq ?type nil))
            then
            (if (not (> ?recommended-weight 0)) ;Recommended weight should be greater than 0 for weight exercises (assigned)
                then
                (printout t "Error: For exercise " ?exercise ", to have reccommended weight but got 0" crlf)
                (bind ?success FALSE)
            )
            else
            (if (> ?recommended-weight 0) ;Non weight exercises should have 0 recommended weight
                then
                (printout t "Error: For exercise " ?exercise ", got reccommended weight but expected 0" crlf)
                (bind ?success FALSE)
            )
        )
    )

    (if ?success
        then
        (printout t "OK: Weight recommendation assigned correctly" crlf)
    )
)

(deffunction test-fitness-level-assigned ()
    (if (not (any-factp ((?f fitness-level)) TRUE))
        then
        (printout t "Error: No fitness level fact found, fitness level not assigned" crlf)
    else
        (bind ?fla (nth$ 1 (find-all-facts ((?f fitness-level)) TRUE)))
    )
)


(deffunction run-test-case-weight-recommendation (?bmi ?activity-level)
    (printout t "===========================================================================================================" crlf)
    (printout t "Test input: BMI: " ?bmi ", Activity Level: " ?activity-level crlf)
    (reset)
    (bind ?above-bmi (+ ?bmi 1.0))
    (bind ?below-bmi (- ?bmi 1.0))
    (assert (bmi (?below-bmi 0.0) (?bmi 1.0) (?above-bmi 0.0)))
    (bind ?above-activity (+ ?activity-level 1.0))
    (bind ?below-activity (- ?activity-level 1.0))
    (assert (activity-level (?below-activity 0.0) (?activity-level 1.0) (?above-activity 0.0)))
    (focus FITNESS-LEVEL)
    (run)
    (test-weight-recommendation-assignment)
    (test-fitness-level-assigned)
    (focus MAIN)

)
(deffunction test-weight-recommendation ()
    (printout t "Testing weight recommendation assessment:" crlf)
    (run-test-case-weight-recommendation 17 1)
    (run-test-case-weight-recommendation 17 60)
    (run-test-case-weight-recommendation 17 150)
    (run-test-case-weight-recommendation 17 300)
    (run-test-case-weight-recommendation 17 400)
    (run-test-case-weight-recommendation 18.5 1)
    (run-test-case-weight-recommendation 18.5 60)
    (run-test-case-weight-recommendation 18.5 150)
    (run-test-case-weight-recommendation 18.5 300)
    (run-test-case-weight-recommendation 18.5 400)
    (run-test-case-weight-recommendation 22 1)
    (run-test-case-weight-recommendation 22 60)
    (run-test-case-weight-recommendation 22 150)
    (run-test-case-weight-recommendation 22 300)
    (run-test-case-weight-recommendation 22 400)
    (run-test-case-weight-recommendation 24.9 1)
    (run-test-case-weight-recommendation 24.9 60)
    (run-test-case-weight-recommendation 24.9 150)
    (run-test-case-weight-recommendation 24.9 300)
    (run-test-case-weight-recommendation 24.9 400)
    (run-test-case-weight-recommendation 27 1)
    (run-test-case-weight-recommendation 27 60)
    (run-test-case-weight-recommendation 27 150)
    (run-test-case-weight-recommendation 27 300)
    (run-test-case-weight-recommendation 27 400)
    (run-test-case-weight-recommendation 40 1)
    (run-test-case-weight-recommendation 40 60)
    (run-test-case-weight-recommendation 40 150)
    (run-test-case-weight-recommendation 40 300)
    (run-test-case-weight-recommendation 40 400)
)
