; Facts

; Muscle group template
(deftemplate muscle-group
   (slot name)
   (slot priority (allowed-values high medium low))
   (slot region (allowed-values upper lower))
   (slot type (allowed-values push pull leg))
)


; Sub-muscle group template
(deftemplate sub-muscle-group
   (slot main-muscle-group)
   (slot name)
   (slot priority (allowed-values high medium low))
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
)

; Workout split template
(deftemplate workout-split
   (slot name)
   (multislot days)
)

; Day template
(deftemplate day
   (slot name)
   (slot focus)
   (multislot exercises)
)

; Exercise slot template for day
(deftemplate exercise-slot
   (slot primary-muscle-group) 
   (slot order (type INTEGER)) 
)

; User input template
(deftemplate user-input
   (slot goal)
   (slot frequency)
   (slot muscle-group)
   (slot time)
   (slot exercise-type)
)
