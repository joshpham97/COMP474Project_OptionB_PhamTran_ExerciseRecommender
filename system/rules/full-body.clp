; Initial full body workout split
(defrule initialize-full-body
   ?split <- (workout-split (name "Full-body"))
   (not (day))
   =>
   (assert (day (name "Day 1") 
                (focus full-body)))
   (assert (day (name "Day 2")
                (focus full-body)))
   (assert (day (name "Day 3")
                (focus full-body)))
)

(defrule initialize-full-body-day-exercise
    ?day <- (day (name ?dname) (focus full-body) (is-initialized nil))
    =>
    (assert(exercise-slot (id 1) (day ?dname) (primary-muscle-group chest)))
    (assert(exercise-slot (id 2) (day ?dname) (primary-muscle-group shoulder)))
    (assert(exercise-slot (id 3) (day ?dname) (primary-muscle-group back)))
    (assert(exercise-slot (id 4) (day ?dname) (primary-muscle-group back)))
    (assert(exercise-slot (id 5) (day ?dname) (primary-muscle-group quads)))
    (assert(exercise-slot (id 6) (day ?dname) (primary-muscle-group hamstring)))
    (modify ?day (is-initialized TRUE))
)

(defrule assign-first-exercise-push
   (workout-split (name "Full-body"))
   (day (name ?d) ))
   ?s <- (exercise-slot
            (day ?d)
            (order 1)
            (primary-muscle-group nil))
   =>
   (if (eq ?d "Day 1") then
        (modify ?s (primary-muscle-group chest))
    else if (eq ?d "Day 2") then
        (modify ?s (primary-muscle-group back))
    else if (eq ?d "Day 3") then
        (modify ?s (primary-muscle-group quad))
    else if (eq ?d "Pull 2") then
        (modify ?s (primary-muscle-group back)))
