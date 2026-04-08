; Contains the mapping from exercise to the exercise type (bench, squat, deadlift)
; Used when apply weigth modifier
(deffacts exercise-type-mapping
   (exercise-type (name dumb-bell-bench-press) (type bench))
   (exercise-type (name barbell-squat)         (type squat))
   (exercise-type (name sissy-squat)           (type squat))
   (exercise-type (name romanian-deadlift)     (type deadlift))
   (exercise-type (name stiff-leg-deadlift)    (type deadlift))
)