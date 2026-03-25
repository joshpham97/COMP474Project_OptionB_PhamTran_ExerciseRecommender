(defmodule MAIN (export deftemplate workout-split day exercise-slot user-input muscle-group sub-muscle-group exercise))

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

; User input template
(deftemplate user-input
   (slot goal)
   (slot frequency)
   (slot muscle-group)
   (slot exercise-type)
)

