(defrule initialize-push-pull-leg-not-frequency-6
   (workout-split (name "Push-Pull-Leg"))
   (user-input (frequency ?f&:(= ?f 6)))
   (not (day))
   =>
   (assert (day (name "Push 1") 
                (focus push)))
   (assert (day (name "Pull 1")
                (focus pull)))
   (assert (day (name "Leg 1")
                (focus leg)))
)

(defrule initialize-push-pull-leg-frequency-6
   (workout-split (name "Push-Pull-Leg"))
   (user-input (frequency 6))
   =>
   (assert (day (name "Push 2") (focus push)))
   (assert (day (name "Pull 2") (focus pull)))
   (assert (day (name "Leg 2")  (focus leg))))

; Initialize template for each day 
(defrule initialize-push-day-exercise
    ?day <- (day (name ?dname) (focus push) (is-initialized nil))
    =>
    (assert(exercise-slot (id 1) (day ?dname) (primary-muscle-group chest)))
    (assert(exercise-slot (id 2) (day ?dname) (primary-muscle-group chest)))
    (assert(exercise-slot (id 3) (day ?dname) (primary-muscle-group shoulder)))
    (assert(exercise-slot (id 4) (day ?dname) (primary-muscle-group shoulder)))
    (assert(exercise-slot (id 5) (day ?dname) (primary-muscle-group triceps)))
    (modify ?day (is-initialized TRUE))
)
(defrule initialize-pull-day-exercise
    ?day <- (day (name ?dname) (focus push) (is-initialized nil))
    =>
    (assert(exercise-slot (id 1) (day ?dname) (primary-muscle-group back)))
    (assert(exercise-slot (id 2) (day ?dname) (primary-muscle-group back)))
    (assert(exercise-slot (id 3) (day ?dname) (primary-muscle-group back)))
    (assert(exercise-slot (id 4) (day ?dname) (primary-muscle-group trap)))
    (assert(exercise-slot (id 5) (day ?dname) (primary-muscle-group triceps)))
    (modify ?day (is-initialized TRUE))
)
(defrule initialize-leg-day-exercise
    ?day <- (day (name ?dname) (focus leg) (is-initialized nil))
    =>
    (assert(exercise-slot (id 1) (day ?dname) (primary-muscle-group quads)))
    (assert(exercise-slot (id 2) (day ?dname) (primary-muscle-group quads)))
    (assert(exercise-slot (id 3) (day ?dname) (primary-muscle-group hamstring)))
    (assert(exercise-slot (id 4) (day ?dname) (primary-muscle-group hamstring)))
    (assert(exercise-slot (id 5) (day ?dname) (primary-muscle-group glutes)))
    (assert(exercise-slot (id 6) (day ?dname) (primary-muscle-group calves)))
    (modify ?day (is-initialized TRUE))
)

; 
(defrule initialize-priority
   ?exercise <- (exercise-slot (primary-muscle-group ?mg) (priority nil))
   ?muscle-group <- (muscle-group (name ?mg) (priority ?p))
   =>
   (modify ?exercise (priority ?p))
)

(defrule assign-first-exercise-push
   (workout-split (name "Push-Pull-Leg"))
   (day (name ?d) (focus ?f))
   ?s <- (exercise-slot
            (day ?d)
            (order 1)
            (primary-muscle-group nil))
   =>
   (if (eq ?d "Push 1") then
        (modify ?s (primary-muscle-group chest))
    else if (eq ?d "Push 2") then
        (modify ?s (primary-muscle-group shoulder))
    else if (eq ?d "Pull 1") then
        (modify ?s (primary-muscle-group back))
    else if (eq ?d "Pull 2") then
        (modify ?s (primary-muscle-group back))
    else if (eq ?d "Leg 1") then
        (modify ?s (primary-muscle-group quads))
    else if (eq ?d "Leg 2") then
        (modify ?s (primary-muscle-group hamstring))))

