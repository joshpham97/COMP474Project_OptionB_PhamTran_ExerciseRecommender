(defmodule FITNESS-LEVEL 
    (import MAIN deftemplate injury-evidence user-input recommendation consultation-required injury-explanation activity-level bmi fitness-level exercise-modifier)
)

(defrule underweight-sedentary-low
  (bmi underweight)
  (activity-level sedentary)
  =>
  (assert (fitness-level low))
)
(defrule underweight-moderate-low
  (bmi underweight)
  (activity-level moderate)
  =>
  (assert (fitness-level low))
)
(defrule underweight-active-medium
  (bmi underweight)
  (activity-level active)
  =>
  (assert (fitness-level medium))
)
(defrule normal-sedentary-low
  (bmi normal)
  (activity-level sedentary)
  =>
  (assert (fitness-level low))
)
(defrule normal-moderate-medium
  (bmi normal)
  (activity-level moderate)
  =>
  (assert (fitness-level medium))
)
(defrule normal-active-high
  (bmi normal)
  (activity-level active)
  =>
  (assert (fitness-level high))
)
(defrule overweight-sedentary-low
  (bmi overweight)
  (activity-level sedentary)
  =>
  (assert (fitness-level low))
)
(defrule overweight-moderate-low
  (bmi overweight)
  (activity-level moderate)
  =>
  (assert (fitness-level low))
)
(defrule overweight-active-medium
  (bmi overweight)
  (activity-level active)
  =>
  (assert (fitness-level medium))
)


(defrule calculate-recommended-weight
    (declare (salience -10))
   ?fl <- (fitness-level ?)
   =>
    (bind ?fs (get-fs ?fl))
    (bind ?fitness-score (moment-defuzzify ?fl)) ; Get the defuzzified value, the middle
    (printout t "Fitness score: " ?fs crlf)
    (printout t "Fitness score: " ?fitness-score crlf)
    (bind ?percentage
      (if (<= ?fitness-score 3.0)
         then (+ 45 (* (/ ?fitness-score 3.0) 15))
         else (if (<= ?fitness-score 7.0)
            then (+ 60 (* (/ (- ?fitness-score 3.0) 4.0) 15))
            else (+ 80 (* (/ (- ?fitness-score 7.0) 3.0) 20))
         )
      )
   )

   (assert (recommended-weight ?percentage))
)

; A low priority rule to focus back on MAIN after fitness level is assessed
(defrule fitness-assessment-done
   (declare (salience -100))
   (fitness-level ?)
   =>
   (focus MAIN)
)
