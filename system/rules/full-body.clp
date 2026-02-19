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

(defrule assign-first-fullbody-day1
   (workout-split (name "Full-body"))
   (day (name "Day 1") (focus full-body))
   (not (exercise-slot (day "Day 1") (order 1)))
   ?s <- (exercise-slot (day "Day 1") (order nil))
   =>
   (modify ?s (primary-muscle-group chest) (order 1))
)
(defrule assign-first-fullbody-day21
   (workout-split (name "Full-body"))
   (day (name "Day 2") (focus full-body))
   (not (exercise-slot (day "Day 2") (order 1)))
   ?s <- (exercise-slot (day "Day 2") (order nil))
   =>
   (modify ?s (primary-muscle-group back) (order 1))
)
(defrule assign-first-fullbody-day3
   (workout-split (name "Full-body"))
   (day (name "Day 3") (focus full-body))
   (not (exercise-slot (day "Day 3") (order 1)))
   ?s <- (exercise-slot (day "Day 3") (order nil))
   =>
   (modify ?s (primary-muscle-group quads) (order 1))
)