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

(deffunction check-exercise-selection ()
   (do-for-all-facts ((?f exercise-slot))
      (= (fact-slot-value ?f exercise-order) 1)
      
      (bind ?user-input (nth$ 1 (find-all-facts ((?ui user-input)) TRUE)))
      (bind ?muscle-group (fact-slot-value ?user-input muscle-group))
      (bind ?exercise (fact-slot-value ?f exercise))
      (bind ?day (fact-slot-value ?f day-order))

      (printout t "Checking first exercise selection for Day " ?day crlf)

      (if (not (eq (fact-slot-value ?f primary-muscle-group) ?muscle-group))
         then (printout t "Error: Exercise " ?exercise " does not target the selected muscle group " ?muscle-group crlf)
      )
   )
)
(deffunction is-small-muscle-group (?muscle)
   (member$ ?muscle (create$ biceps triceps glutes calves))
)

(deffunction check-small-muscle-group-ordering ()
   (do-for-all-facts ((?f exercise-slot)) TRUE
      (bind ?current-muscle (fact-slot-value ?f primary-muscle-group))
      (bind ?current-order  (fact-slot-value ?f exercise-order))
      (bind ?current-day    (fact-slot-value ?f day-order))

      (if (is-small-muscle-group ?current-muscle)
         then
         ; Check if there is a next exercise slot on the same day
         (bind ?next (find-all-facts ((?n exercise-slot))
            (and (= (fact-slot-value ?n day-order) ?current-day)
                 (= (fact-slot-value ?n exercise-order) (+ ?current-order 1)))
         ))

         (if (> (length$ ?next) 0)
            then
            (bind ?next-fact   (nth$ 1 ?next))
            (bind ?next-muscle (fact-slot-value ?next-fact primary-muscle-group))

            (if (not (is-small-muscle-group ?next-muscle))
               then
               (printout t "Error: " ?current-muscle " on Day " ?current-day 
                           " (slot " ?current-order ") should come after " ?next-muscle crlf)
               else
               (printout t "OK: " ?current-muscle " and " ?next-muscle 
                           " are both small muscle groups, ordering is fine." crlf)
            )
         )
      )
   )
)
;If a non-preferred equipment exercise is assigned, check that NO unassigned exercises with preferred equipment exist for that muscle group.
(deffunction check-equipment-priority ()
   (bind ?user-input (nth$ 1 (find-all-facts ((?ui user-input)) TRUE)))
   (bind ?preferred-equipment (fact-slot-value ?user-input exercise-type))
   (bind ?found-non-preferred FALSE)

    ; Go through all assigned exercises and check if any of them use non-preferred equipment
   (do-for-all-facts ((?es exercise-slot)) TRUE
      (bind ?exercise-name (fact-slot-value ?es exercise))
      (bind ?muscle        (fact-slot-value ?es primary-muscle-group))

      (do-for-fact ((?e exercise))
         (eq (fact-slot-value ?e name) ?exercise-name)

         (bind ?equipment (fact-slot-value ?e equipment))

         (if (neq ?equipment ?preferred-equipment) ; If the assigned exercise uses non-preferred equipment
            then
            (bind ?found-non-preferred TRUE)

            ; Collect all the exercises that use the preferred equipment for the same muscle group
            (bind ?preferred-names (create$))
            (do-for-all-facts ((?pe exercise))
               (and (eq (fact-slot-value ?pe equipment) ?preferred-equipment)
                    (eq (fact-slot-value ?pe primary-muscle-group) ?muscle))
               (bind ?preferred-names (insert$ ?preferred-names 1 (fact-slot-value ?pe name)))
            )

            ; Collect all assigned exercise names
            (bind ?assigned-names (create$))
            (do-for-all-facts ((?as exercise-slot)) TRUE
               (bind ?assigned-names (insert$ ?assigned-names 1 (fact-slot-value ?as exercise)))
            )

            ; Check if all the preferred exercises is used up in assigned exercises
            (bind ?exhausted TRUE)
            (progn$ (?pn ?preferred-names)
               (if (not (member$ ?pn ?assigned-names))
                  then (bind ?exhausted FALSE)
               )
            )

            ; Print out the result for this non-preferred exercise
            (if ?exhausted
               then (printout t "OK: " ?exercise-name " | " ?equipment
                               " (all " ?preferred-equipment " exhausted for " ?muscle ")" crlf)
               else (printout t "FAIL: " ?exercise-name " | " ?equipment
                               " (" ?preferred-equipment " still available for " ?muscle ")" crlf)
            )
         )
      )
   )
   ; If we never found a non-preferred exercise, then all exercises use preferred equipment, so print OK
   (if (not ?found-non-preferred)
      then
      (printout t "OK: All exercises use preferred equipment (" ?preferred-equipment ")" crlf)
   )
)


(deffunction run-tests ()
    (check-exercise-slots)
    (check-muscle-groups)
    (check-exercises)
    (check-exercise-selection)
    (check-small-muscle-group-ordering)
    (check-equipment-priority)
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