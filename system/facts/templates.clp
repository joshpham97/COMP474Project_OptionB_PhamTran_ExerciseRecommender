(defmodule MAIN (export deftemplate 
   workout-split 
   day exercise-slot 
   user-input 
   muscle-group 
   sub-muscle-group 
   exercise
   consultation-required 
   recommendation 
   injury-evidence
   injury-explanation
   activity-level
   bmi
   fitness-level
   exercise-modifier
))

; Facts

; Muscle group template
(deftemplate muscle-group
   (slot name)
   (slot priority (allowed-values 1 2 3)) ; 1 = high, 2 = medium, 3 = low
   (slot region (allowed-values upper lower))
   (slot type (allowed-values push pull leg))
)


; Sub-muscle group template
(deftemplate sub-muscle-group
   (slot main-muscle-group)
   (slot name)
   (slot priority (allowed-values 1 2 3 4)) ; 1 = high, 2 = medium, 3 = low
)


;  Exercise template
(deftemplate exercise
   (slot id)
   (slot name)
   (slot primary-muscle-group)
   (slot targeted-sub-muscle-group)
   (multislot secondary-muscle-groups)
   (slot movement (allowed-values compound isolation))
   (slot equipment (allowed-values free-weight machine bodyweight))
   (slot set)
)

; Workout split template
(deftemplate workout-split
   (slot name)
)

; Day template
(deftemplate day
   (slot order)
   (slot name)
   (slot focus)
)

; Exercise slot template for day
(deftemplate exercise-slot
   (slot exercise-order) 
   (slot day-order)
   (slot global-order) ; A global order of exercise among all exercise to make inference easier
   (slot primary-muscle-group) 
   (slot targeted-sub-muscle-group)
   (slot exercise)
   (slot min-reps (default 0))
   (slot max-reps (default 0))
   (slot sets (default 0))
)

(deftemplate exercise-modifier
   (slot name)
   (slot modifier)
   (slot gender)
)

; https://iris.who.int/server/api/core/bitstreams/faa83413-d89e-4be9-bb01-b24671aef7ca/content
(deftemplate activity-level
   0 10000 minutes/week
   (
      (sedentary (0 1) (60 1) (150 0))
      (moderate  (60 0) (180 1) (300 0))
      (active    (300 0) (600 1) (10000 1))
   )
)
; https://www.cdc.gov/bmi/adult-calculator/bmi-categories.html#:~:text=BMI%20categories%20for%20adults%20BMI%20is%20a,BMI%20regardless%20of%20age%2C%20sex%2C%20or%20race
(deftemplate bmi
  10 45 kg/m2
  (
    (underweight (10 1) (18.5 1) (24.9 0))
    (normal      (18.5 0) (21.7 1) (24.9 0))
    (overweight  (24.9 0) (30.0 1) (40 1))
  )
)

; https://pmc.ncbi.nlm.nih.gov/articles/PMC4643425/
; https://link.springer.com/article/10.1186/s12889-020-08517-8
(deftemplate fitness-level
  0 10 score
  (
    (low    (0 1) (3.0 1) (5.0 0))
    (medium (3.0 0) (5.0 1) (7.0 0))
    (high   (5.0 0) (8.0 1) (10 1))
  )
)
; User input template
(deftemplate user-input
   (slot goal)
   (slot frequency)
   (slot muscle-group)
   (slot exercise-type)
   (slot age)
   (slot experience)
   (slot has-previous-injury)
   (slot gender)
   (slot height)
   (slot weight)
)

