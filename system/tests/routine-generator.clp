(deffunction test-print-exercise-slots (?f)
    (printout t "Day " (fact-slot-value ?f day-order) 
                   "| Slot " (fact-slot-value ?f exercise-order)
                   "| Muscle " (fact-slot-value ?f primary-muscle-group)
                   "| Exercise " (fact-slot-value ?f exercise) crlf)
)

; Check to ensure exercise-slot are generated
(deffunction check-exercise-slots ()
    (if (not (any-factp ((?s exercise-slot)) TRUE))
      then (printout t "Error: No exercise slots found" crlf)
      else (printout t "OK: Exercise slots exist" crlf))
)

; Check to ensure no nil values are being assigned to muscle groups
(deffunction check-muscle-groups ()
    (do-for-all-facts ((?f exercise-slot))
        (eq (fact-slot-value ?f primary-muscle-group) nil)
        (progn
            (printout t "Error: Found an exercise slot with nil primary muscle group." crlf)
            (test-print-exercise-slots ?f)
        )
    )
)
; Check to ensure no nil values are being assigned to exercise
(deffunction check-exercises ()
    (do-for-all-facts ((?f exercise-slot))
        (eq (fact-slot-value ?f exercise) nil)
        (progn
            (printout t "Error: Found an exercise slot with nil exercise." crlf)
            (test-print-exercise-slots ?f)
        )
    )
)

(deffunction run-tests ()
    (check-exercise-slots)
    (check-muscle-groups)
    (check-exercises)
)

(deffunction test-function (?goal ?frequency ?muscle-group ?exercise-type)
    (printout t "===========================================================================================================" crlf)
    (printout t "Running test with Goal: " ?goal ", Frequency: " ?frequency ", Muscle Group: " ?muscle-group ", Exercise Type: " ?exercise-type crlf)
    (reset)
    (do-for-all-facts ((?ui user-input)) TRUE
        (modify ?ui (goal ?goal) (frequency ?frequency) (muscle-group ?muscle-group) (exercise-type ?exercise-type)))
    (run)
    (run-tests)
)

; TODO: Add mote test cases
(deffunction test-routine-generator ()
    (test-function strength 3 chest free-weight)
    (test-function strength 4 back machine)
    (test-function strength 6 shoulder free-weight)
    (test-function hypertrophy 3 quads machine)
    (test-function hypertrophy 3 hamstring machine)
    (test-function hypertrophy 4 chest free-weight)
    (test-function hypertrophy 6 back machine)
)