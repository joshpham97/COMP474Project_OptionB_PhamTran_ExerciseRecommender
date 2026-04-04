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
      (has-previous-injury nil))
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
   (input-previous-injury))
