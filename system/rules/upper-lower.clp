(defrule initialize-upper-lower
   ?split <- (workout-split (name "Upper-Lower"))
   (not (day))
   =>
   (assert (day (name "Upper 1")
                (focus upper))
   )
   (assert (day (name "Lower 1")
                (focus lower))
   )
   (assert (day (name "Upper 2")
                (focus upper))
   )
   (assert (day (name "Lower 2")
                (focus lower))
   )
)

(defrule initialize-upper-day-exercise
    ?day <- (day (name ?dname) (focus upper) (is-initialized nil))
    =>
    (assert(exercise-slot (id 1) (day ?dname) (primary-muscle-group chest)))
    (assert(exercise-slot (id 2) (day ?dname) (primary-muscle-group back)))
    (assert(exercise-slot (id 3) (day ?dname) (primary-muscle-group chest)))
    (assert(exercise-slot (id 4) (day ?dname) (primary-muscle-group back)))
    (assert(exercise-slot (id 5) (day ?dname) (primary-muscle-group biceps)))
    (assert(exercise-slot (id 6) (day ?dname) (primary-muscle-group triceps)))
    (modify ?day (is-initialized TRUE))
)

(defrule initialize-lower-day-exercise
    ?day <- (day (name ?dname) (focus lower) (is-initialized nil))
    =>
    (assert(exercise-slot (id 1) (day ?dname) (primary-muscle-group quads)))
    (assert(exercise-slot (id 2) (day ?dname) (primary-muscle-group hamstring)))
    (assert(exercise-slot (id 3) (day ?dname) (primary-muscle-group quads)))
    (assert(exercise-slot (id 4) (day ?dname) (primary-muscle-group hamstring)))
    (assert(exercise-slot (id 5) (day ?dname) (primary-muscle-group glutes)))
    (assert(exercise-slot (id 6) (day ?dname) (primary-muscle-group calves)))
    (modify ?day (is-initialized TRUE))
)

(defrule initialize-priority
   ?exercise <- (exercise-slot (primary-muscle-group ?mg) (priority nil))
   ?muscle-group <- (muscle-group (name ?mg) (priority ?p))
   =>
   (modify ?exercise (priority ?p))
)

(defrule assign-first-exercise-by-weakpoint
   (day (name ?dname) (focus ?f))
   (user-input (muscle-group ?mg))
   ?mg-fact <- (muscle-group (name ?mg) (region ?f))
   (not (exercise-slot (day ?dname) (order 1)))
   ?exercise <- (exercise-slot (day ?dname) (primary-muscle-group ?mg) (priority ?p&~nil) (order nil))
   =>
   (modify ?exercise (order 1))
)

(defrule assign-first-exercise-lower
   (day (name ?d2name) (focus ?f))
   (day (name ?d1name) (focus ?f))
   (test (neq ?d1name ?d2name))
   (test (eq ?f lower))
   (not (exercise-slot (day ?d1name) (order 1)))
   (not (exercise-slot (day ?d2name) (order 1)))
   ?exercise1 <- (exercise-slot (day ?d1name) (primary-muscle-group quads) (order nil))
   ?exercise2 <- (exercise-slot (day ?d2name) (primary-muscle-group hamstring) (order nil))
   =>
   (modify ?exercise1 (order 1))
   (modify ?exercise2 (order 1))
)

(defrule assign-first-exercise-upper
   (day (name ?d2name) (focus ?f))
   (day (name ?d1name) (focus ?f))
   (test (neq ?d1name ?d2name))
   (test (eq ?f upper))
   (not (exercise-slot (day ?d1name) (order 1)))
   (not (exercise-slot (day ?d2name) (order 1)))
   ?exercise1 <- (exercise-slot (day ?d1name) (primary-muscle-group chest) (order nil))
   ?exercise2 <- (exercise-slot (day ?d2name) (primary-muscle-group back) (order nil))
   =>
   (modify ?exercise1 (order 1))
   (modify ?exercise2 (order 1))
)

