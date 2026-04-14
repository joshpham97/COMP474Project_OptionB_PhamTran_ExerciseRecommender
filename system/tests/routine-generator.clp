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
        (bind ?muscle (fact-slot-value ?es primary-muscle-group))

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

(deffunction is-upper-muscle-group (?muscle)
   (member$ ?muscle (create$ chest back shoulder biceps triceps))
)

(deffunction is-lower-muscle-group (?muscle)
   (member$ ?muscle (create$ quads hamstring glutes calves))
)
; Upper-Lower: Exercises should alternate between muscle groups of the same region (1 test for upper and 1 test for lower).
; TODO: Doesn't cehck for alternating, but does check that it's in the right region
(deffunction check-upper-lower-ordering ()
   (bind ?workout-split (nth$ 1 (find-all-facts ((?ws workout-split)) TRUE)))
   (if (not (eq (fact-slot-value ?workout-split name) "Upper-Lower"))
      then (return TRUE)
   )

   (bind ?days (find-all-facts ((?d day)) TRUE))

   (progn$ (?day ?days)
      (bind ?day-order (fact-slot-value ?day order))
      (bind ?is-upper  (or (eq ?day-order 1) (eq ?day-order 3)))
      (bind ?previous-muscle nil)

      ; Get max exercise order for this day
      (bind ?max-order 0)
      (do-for-all-facts ((?es exercise-slot))
         (= (fact-slot-value ?es day-order) ?day-order)
         (if (> (fact-slot-value ?es exercise-order) ?max-order)
            then (bind ?max-order (fact-slot-value ?es exercise-order))
         )
      )

      (printout t crlf "Day " ?day-order " (" (if ?is-upper then "Upper" else "Lower") "):" crlf)

      ; Loop through exercises in order
      (loop-for-count (?i 1 ?max-order)
         (do-for-fact ((?es exercise-slot))
            (and (= (fact-slot-value ?es day-order) ?day-order)
                 (= (fact-slot-value ?es exercise-order) ?i))

            (bind ?current-muscle (fact-slot-value ?es primary-muscle-group))

            ; Check correct region
            (if ?is-upper
               then
               (if (not (is-upper-muscle-group ?current-muscle))
                  then (printout t "FAIL | Slot " ?i " - " ?current-muscle " is lower body on upper day" crlf)
               else
                  (if (and (neq ?previous-muscle nil) (eq ?current-muscle ?previous-muscle)) ; Check that it's not the same muscle group as previous exercise
                     then (printout t "FAIL: Slot " ?i " - consecutive same muscle " ?current-muscle crlf)
                     else (printout t "OK: Slot " ?i " - " ?current-muscle crlf)
                  )
               )
            else
               (if (not (is-lower-muscle-group ?current-muscle))
                  then (printout t "FAIL | Slot " ?i " - " ?current-muscle " is upper body on lower day" crlf)
               else
                  (if (and (neq ?previous-muscle nil) (eq ?current-muscle ?previous-muscle))
                     then (printout t "FAIL: Slot " ?i " - consecutive same muscle " ?current-muscle crlf)
                     else (printout t "OK: Slot " ?i " - " ?current-muscle crlf)
                  )
               )
            )

            (bind ?previous-muscle ?current-muscle)
         )
      )
   )
)

(deffunction is-push-muscle-group (?muscle)
   (member$ ?muscle (create$ chest shoulder triceps))
)

(deffunction is-leg-muscle-group (?muscle)
   (member$ ?muscle (create$ quads hamstring glutes calves))
)

(deffunction is-pull-muscle-group (?muscle)
   (member$ ?muscle (create$ back biceps))
)

(deffunction check-ppl-ordering ()
   (bind ?workout-split (nth$ 1 (find-all-facts ((?ws workout-split)) TRUE)))
   (if (not (eq (fact-slot-value ?workout-split name) "Push-Pull-Leg"))
      then (return TRUE)
   )
   (printout t "Checking Push-Pull-Leg ordering..." crlf)

   (bind ?days (find-all-facts ((?d day)) TRUE))

   (progn$ (?day ?days)
      (bind ?day-order (fact-slot-value ?day order))
      (bind ?day-focus (fact-slot-value ?day focus))
      (bind ?previous-muscle nil)

      ; Get max exercise order for this day
      (bind ?max-order 0)
      (do-for-all-facts ((?es exercise-slot))
         (= (fact-slot-value ?es day-order) ?day-order)
         (if (> (fact-slot-value ?es exercise-order) ?max-order)
            then (bind ?max-order (fact-slot-value ?es exercise-order))
         )
      )

      (printout t crlf "Day " ?day-order " (" ?day-focus "):" crlf)

      (loop-for-count (?i 1 ?max-order)
         (do-for-fact ((?es exercise-slot))
            (and (= (fact-slot-value ?es day-order) ?day-order)
                 (= (fact-slot-value ?es exercise-order) ?i))

            (bind ?current-muscle (fact-slot-value ?es primary-muscle-group))

            (if (eq ?day-focus pull)
               then
               ; Pull day - all backs and biceps on last day
               (if (not (or (eq ?current-muscle back)  
                            (and (eq ?current-muscle biceps) (eq ?i ?max-order))
                        ))
                  then (printout t "FAIL: Slot " ?i " - " ?current-muscle " is not back on pull day" crlf)
                  else (printout t "OK: Slot " ?i " - " ?current-muscle " on pull day" crlf)
               )

            else (if (eq ?day-focus push)
               then
               ; Push day - chest/shoulder/triceps, should alternate
               (if (not (is-push-muscle-group ?current-muscle))
                  then (printout t "FAIL | Slot " ?i " - " ?current-muscle " is not a push muscle on push day" crlf)
               else
                  (if (and (neq ?previous-muscle nil) (eq ?current-muscle ?previous-muscle))
                     then (printout t "FAIL: Slot " ?i " - consecutive same muscle " ?current-muscle " on push day" crlf)
                     else (printout t "OK: Slot " ?i " - " ?current-muscle " on push day" crlf)
                  )
               )

            else (if (eq ?day-focus legs)
               then
               ; Legs day - quads/hamstring/glutes/calves, should alternate
               (if (not (is-leg-muscle-group ?current-muscle))
                  then (printout t "FAIL | Slot " ?i " - " ?current-muscle " is not a leg muscle on legs day" crlf)
               else
                  (if (and (neq ?previous-muscle nil) (eq ?current-muscle ?previous-muscle))
                     then (printout t "FAIL: Slot " ?i " - consecutive same muscle " ?current-muscle " on legs day" crlf)
                     else (printout t "OK: Slot " ?i " - " ?current-muscle " on legs day" crlf)
                  )
               )
            )))

            (bind ?previous-muscle ?current-muscle)
         )
      )
   )
)

;Full body: A day must cover all major muscle groups, except glutes and calves
(deffunction check-full-body-ordering ()
   (bind ?workout-split (nth$ 1 (find-all-facts ((?ws workout-split)) TRUE)))
   (if (not (eq (fact-slot-value ?workout-split name) "Full-body"))
      then (return TRUE)
   )

   ; Define required muscle groups (excluding glutes)
   (bind ?required-muscles (create$ chest back shoulder quads hamstring biceps triceps))

   (bind ?days (find-all-facts ((?d day)) TRUE))

   (progn$ (?day ?days)
      (bind ?day-order (fact-slot-value ?day order))

      (printout t crlf "Day " ?day-order ":" crlf)

      ; Collect all muscles assigned this day
      (bind ?assigned-muscles (create$))
      (do-for-all-facts ((?es exercise-slot))
         (= (fact-slot-value ?es day-order) ?day-order)
         (bind ?muscle (fact-slot-value ?es primary-muscle-group))
         (if (not (member$ ?muscle ?assigned-muscles))
            then (bind ?assigned-muscles (insert$ ?assigned-muscles 1 ?muscle))
         )
      )

      (printout t "Assigned muscles: " ?assigned-muscles crlf)

      ; Check each required muscle is covered
      (bind ?all-covered TRUE)
      (progn$ (?required ?required-muscles)
         (if (not (member$ ?required ?assigned-muscles))
            then
            (bind ?all-covered FALSE)
            (printout t "FAIL: " ?required " is not covered" crlf)
            else
            (printout t "OK: " ?required " is covered" crlf)
         )
      )

      (if ?all-covered
         then (printout t "OK: All required muscle groups covered on Day " ?day-order crlf)
      )
   )
)



(deffunction run-tests ()
    (check-exercise-slots)
    (check-muscle-groups)
    (check-exercises)
    (check-exercise-selection)
    (check-small-muscle-group-ordering)
    (check-equipment-priority)
    (check-upper-lower-ordering)
    (check-ppl-ordering)
    (check-full-body-ordering)
)

(deffunction test-function (?goal ?frequency ?muscle-group ?exercise-type)
    (printout t "===========================================================================================================" crlf)
    (printout t "Running test with Goal: " ?goal ", Frequency: " ?frequency ", Muscle Group: " ?muscle-group ", Exercise Type: " ?exercise-type crlf)
    (reset)
    (do-for-all-facts ((?ui user-input)) TRUE
        (modify ?ui (goal ?goal) (frequency ?frequency) (muscle-group ?muscle-group) (exercise-type ?exercise-type)))
    (run)
    (focus ROUTINE-GENERATOR)
    (run)
    (focus MAIN)
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