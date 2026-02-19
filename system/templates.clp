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
   (slot priority (allowed-values 1 2 3)) ; 1 = high, 2 = medium, 3 = low
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
   (slot name)
   (slot focus)
   (slot is-initialized)
)

; Exercise slot template for day
(deftemplate exercise-slot
   (slot id) ; allow creating similar facts within the same day
   (slot day)
   (slot primary-muscle-group) 
   (slot exercise)
   (slot min-reps (default 0))
   (slot max-reps (default 0))
   (slot sets (default 0))
   (slot order)
   (slot priority)
)

; User input template
(deftemplate user-input
   (slot goal)
   (slot frequency)
   (slot muscle-group)
   (slot time)
   (slot exercise-type)
)

; Helper templates for exercise selection

(deftemplate candidate-exercise
   (slot day)
   (slot slot-id)
   (slot muscle-group)
   (slot exercise-id)
   (slot priority)
)

(deftemplate candidate-initialized
   (slot day)
   (slot slot-id)
)

(deftemplate to-be-processed
   (slot day)
   (slot id)
)
