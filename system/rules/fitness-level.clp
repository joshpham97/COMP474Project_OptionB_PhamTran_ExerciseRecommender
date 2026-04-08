(defmodule FITNESS-LEVEL 
    (import MAIN deftemplate injury-evidence user-input recommendation consultation-required injury-explanation activity-level 
    bmi fitness-level exercise-modifier fitness-level-adjustment exercise-type)
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

(defrule calculate-recommended-weight-percentage
    (declare (salience -10))
    ?fl <- (fitness-level ?)
     =>
    (bind ?fitness-score (moment-defuzzify ?fl)) ; Get the defuzzified value, the center-of-gravity

    ; Claude AI - prompt: How should I calculate percentage based on fitness score in CLIPS?
    (bind ?percentage
      (if (<= ?fitness-score 3.0)
          then (+ 45 (* (/ ?fitness-score 3.0) 15))           ; 45% to 60%  (score 0-3)
      else (if (<= ?fitness-score 7.0)
          then (+ 60 (* (/ (- ?fitness-score 3.0) 4.0) 15))   ; 60% to 75%  (score 3-7)
      else
          (+ 80 (* (/ (- ?fitness-score 7.0) 3.0) 20))        ; 80% to 100% (score 7-10)
      ))
    )
   (assert (fitness-level-adjustment (value ?percentage)))
)

; A low priority rule to focus back on MAIN after fitness level is assessed
(defrule fitness-assessment-done
   (declare (salience -100))
   (fitness-level ?)
   =>
   (focus MAIN)
)
