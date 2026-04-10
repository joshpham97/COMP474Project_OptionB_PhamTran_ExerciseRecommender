; Getting user input

;- Goal: Strength or Hypertrophy
;- Frequency: 3,4,6
;- Primary muscle group: Chest, Back, Shoulder, Legs
;- Exercise type preference: Free weight, Machine

; Initial rule to set up the user-input fact
(deffacts init-user
   (user-input
      (goal nil)
      (frequency 0)
      (muscle-group nil)
      (exercise-type nil)
      (age 0)
      (experience nil)
      (has-previous-injury nil)
      (gender nil)
      (height 0)
      (weight 0)
   )
)

(deffunction set-goal (?g)
   (do-for-all-facts
      ((?ui user-input))
      TRUE
      (modify ?ui (goal ?g))
   )
)

(deffunction set-frequency (?f)
   (do-for-all-facts
      ((?ui user-input))
      TRUE
      (modify ?ui (frequency ?f))
   )
)

(deffunction set-muscle-group (?m)
   (do-for-all-facts
      ((?ui user-input))
      TRUE
      (modify ?ui (muscle-group ?m))
   )
)

(deffunction set-exercise-type (?e)
   (do-for-all-facts
      ((?ui user-input))
      TRUE
      (modify ?ui (exercise-type ?e))
   )
)

(deffunction set-age (?a)
   (do-for-all-facts
      ((?ui user-input))
      TRUE
      (modify ?ui (age ?a))
   )
)

(deffunction set-experience (?e)
   (do-for-all-facts
      ((?ui user-input))
      TRUE
      (modify ?ui (experience ?e))
   )
)

(deffunction set-has-previous-injury (?p)
   (do-for-all-facts
      ((?ui user-input))
      TRUE
      (modify ?ui (has-previous-injury ?p))
   )
)

(deffunction set-gender (?g)
   (do-for-all-facts
      ((?ui user-input))
      TRUE
      (modify ?ui (gender ?g))
   )
)
(deffunction set-height (?h)
   (do-for-all-facts
      ((?ui user-input))
      TRUE
      (modify ?ui (height ?h))
   )
)
(deffunction set-weight (?w)
   (do-for-all-facts
      ((?ui user-input))
      TRUE
      (modify ?ui (weight ?w))
   )
)

(deffunction input-goal ()
   (printout t "Please enter your goal number: " crlf)
   (printout t "1. Strength" crlf)
   (printout t "2. Hypertrophy" crlf)

   (bind ?input (read))

   (if (or (not (integerp ?input)) (not (member$ ?input (create$ 1 2))))
      then
      (printout t "Invalid input. Please enter 1 or 2." crlf)
      (input-goal)
   else
      (if (= ?input 1)
         then
         (set-goal strength)
      else
         (set-goal hypertrophy))
   )
)

(deffunction input-frequency ()
   (printout t "Please enter your training frequency number: " crlf)
   (printout t "3 days per week" crlf)
   (printout t "4 days per week" crlf)
   (printout t "6 days per week" crlf)

   (bind ?input (read))
   (if (or (not (integerp ?input)) (not (member$ ?input (create$ 3 4 6))))
      then
      (printout t "Invalid input. Please enter a number either 3, 4 or 6." crlf)
      (input-frequency)
   else
      (set-frequency ?input)))

(deffunction input-muscle-group ()
   (printout t "Please enter your primary muscle group number: " crlf)
   (printout t "1. Chest" crlf)
   (printout t "2. Back" crlf)
   (printout t "3. Shoulders" crlf)
   (printout t "4. Quads" crlf)
   (printout t "5. Hamstring" crlf)

   (bind ?input (read))

   (if (or (not (integerp ?input)) (not (member$ ?input (create$ 1 2 3 4 5))))
      then
      (printout t "Invalid input. Please enter a number between 1 and 5." crlf)
      (input-muscle-group)
   else
      (if (= ?input 1)
         then
         (set-muscle-group chest)
      else
         (if (= ?input 2)
            then
            (set-muscle-group back)
         else
            (if (= ?input 3)
               then
               (set-muscle-group shoulder)
            else
               (if (= ?input 4)
                  then
                  (set-muscle-group quads)
               else
                  (set-muscle-group hamstring)))))))

(deffunction input-exercise-type ()
   (printout t "Please enter your preferred exercise type number: " crlf)
   (printout t "1. Free weight" crlf)
   (printout t "2. Machine" crlf)

   (bind ?input (read))

   (if (or (not (integerp ?input)) (not (member$ ?input (create$ 1 2))))
      then
      (printout t "Invalid input. Please enter 1 or 2." crlf)
      (input-exercise-type)
   else
      (if (= ?input 1)
         then
         (set-exercise-type free-weight)
      else
         (set-exercise-type machine))))

(deffunction input-age ()
   (printout t "Please enter your age (1-99): " crlf)

   (bind ?input (read))

   (if (or (not (integerp ?input)) (< ?input 1) (> ?input 99))
      then
      (printout t "Invalid input. Please enter a number between 1 and 99." crlf)
      (input-age)
   else
      (set-age ?input))
)

(deffunction input-experience ()
   (printout t "Do you have previous strength training experience? " crlf)
   (printout t "1. Yes" crlf)
   (printout t "2. No" crlf)

   (bind ?input (read))

   (if (or (not (integerp ?input)) (not (member$ ?input (create$ 1 2))))
      then
      (printout t "Invalid input. Please enter 1 or 2." crlf)
      (input-experience)
   else
      (if (= ?input 1)
         then
         (set-experience yes)
      else
         (set-experience no)))
)

(deffunction input-previous-injury ()
   (printout t "Do you have a previous injury? " crlf)
   (printout t "1. Yes" crlf)
   (printout t "2. No" crlf)

   (bind ?input (read))

   (if (or (not (integerp ?input)) (not (member$ ?input (create$ 1 2))))
      then
      (printout t "Invalid input. Please enter 1 or 2." crlf)
      (input-previous-injury)
   else
      (if (= ?input 1)
         then
         (set-has-previous-injury yes)
      else
         (set-has-previous-injury no)))
)

(deffunction input-gender ()
   (printout t "Please enter your gender: " crlf)
   (printout t "1. Male" crlf)
   (printout t "2. Female" crlf)
   (bind ?input (read))
   (if (or (not (integerp ?input)) (not (member$ ?input (create$ 1 2))))
      then
      (printout t "Invalid input. Please enter 1 or 2." crlf)
      (input-gender)
   else
      (if (= ?input 1)
         then
         (set-gender male)
      else
         (set-gender female)))
)

(deffunction input-height ()
   (printout t "Please enter your height in cm: " crlf)
   (bind ?input (read))
   (if (or (not (integerp ?input)) (< ?input 50) (> ?input 250))
      then
      (printout t "Invalid input. Please enter a number between 50 and 250." crlf)
      (input-height)
   else
      (set-height ?input)))


(deffunction input-weight ()
   (printout t "Please enter your weight in kg: " crlf)
   (bind ?input (read))
   (if (or (not (integerp ?input)) (< ?input 20) (> ?input 500))
      then
      (printout t "Invalid input. Please enter a number between 20 and 500." crlf)
      (input-weight)
   else
      (set-weight ?input)))

; Fuzzy template don't work in another template so these value are kept seperate from user-input
(deffunction input-activity-level ()
   (printout t "Please enter your average weekly activity level in minutes: " crlf)
   (bind ?input (read))
   (if (or (not (integerp ?input)) (< ?input 0) (> ?input 10000))
      then
      (printout t "Invalid input. Please enter a number between 0 and 10000." crlf)
      (input-activity-level)
   else
      ; Add the above/below to ensure exact value input, still fuzzy in the system
      (bind ?above (+ ?input 1.0))
      (bind ?below (- ?input 1.0))
      (assert (activity-level (?below 0.0) (?input 1.0) (?above 0.0))))
)

(deffunction calculate-bmi ()
   (do-for-all-facts
      ((?ui user-input))
      TRUE
      (bind ?height (fact-slot-value ?ui height))
      (bind ?weight (fact-slot-value ?ui weight))
      (if (and (> ?height 0) (> ?weight 0))
         then
         (bind ?height-m (/ ?height 100)) ; Get height in meters
         (bind ?bmi (/ ?weight (* ?height-m ?height-m))) ; BMI formula: weight (kg) / height (m)^2
         
         ; Add the above/below to ensure exact value input, still fuzzy in the system
         (bind ?above (+ ?bmi 1.0))
         (bind ?below (- ?bmi 1.0))
         (assert (bmi (?below 0.0) (?bmi 1.0) (?above 0.0)))
      )
   )
)


(deffunction input-all ()
   (printout t "Getting all the user inputs" crlf)
   (printout t "Please select each option by entering the corresponding number" crlf)
   (input-goal)
   (input-frequency)
   (input-muscle-group)
   ;(input-time)
   (input-exercise-type)
   (input-age)
   (input-experience)
   (input-previous-injury)
   (input-gender)
   (input-height)
   (input-weight)
   (input-activity-level)
   (calculate-bmi)
   )
