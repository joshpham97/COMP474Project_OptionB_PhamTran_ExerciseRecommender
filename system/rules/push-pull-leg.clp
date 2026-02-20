(defrule initialize-push-pull-leg
   (workout-split (name "Push-Pull-Leg"))
   (user-input (frequency 6))
   (not (day))
   =>
   (assert (day (name "Push 1") (focus push)))
   (assert (day (name "Pull 1") (focus pull)))
   (assert (day (name "Leg 1") (focus leg)))
   (assert (day (name "Push 2") (focus push)))
   (assert (day (name "Pull 2") (focus pull)))
   (assert (day (name "Leg 2") (focus leg))))

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
    ?day <- (day (name ?dname) (focus pull) (is-initialized nil))
    =>
    (assert(exercise-slot (id 1) (day ?dname) (primary-muscle-group back)))
    (assert(exercise-slot (id 2) (day ?dname) (primary-muscle-group back)))
    (assert(exercise-slot (id 3) (day ?dname) (primary-muscle-group back)))
    (assert(exercise-slot (id 4) (day ?dname) (primary-muscle-group back)))
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
   (day (name ?d2name) (focus ?f))
   (day (name ?d1name) (focus ?f))
   (test (neq ?d1name ?d2name))
   (test (eq ?f push))
   (not (exercise-slot (day ?d1name) (order 1)))
   (not (exercise-slot (day ?d2name) (order 1)))
   ?exercise1 <- (exercise-slot (day ?d1name) (primary-muscle-group chest) (order nil))
   ?exercise2 <- (exercise-slot (day ?d2name) (primary-muscle-group shoulder) (order nil))
   =>
   (modify ?exercise1 (order 1))
   (modify ?exercise2 (order 1))
)

(defrule assign-first-exercise-pull
   (day (name ?d2name) (focus ?f))
   (day (name ?d1name) (focus ?f))
   (test (neq ?d1name ?d2name))
   (test (eq ?f pull))
   (not (exercise-slot (day ?d1name) (order 1)))
   (not (exercise-slot (day ?d2name) (order 1)))
   ?exercise1 <- (exercise-slot (day ?d1name) (primary-muscle-group back) (order nil))
   ?exercise2 <- (exercise-slot (day ?d2name) (primary-muscle-group back) (order nil))
   =>
   (modify ?exercise1 (order 1))
   (modify ?exercise2 (order 1))
)

(defrule assign-first-exercise-leg
   (day (name ?d2name) (focus ?f))
   (day (name ?d1name) (focus ?f))
   (test (neq ?d1name ?d2name))
   (test (eq ?f leg))
   (not (exercise-slot (day ?d1name) (order 1)))
   (not (exercise-slot (day ?d2name) (order 1)))
   ?exercise1 <- (exercise-slot (day ?d1name) (primary-muscle-group quads) (order nil))
   ?exercise2 <- (exercise-slot (day ?d2name) (primary-muscle-group hamstring) (order nil))
   =>
   (modify ?exercise1 (order 1))
   (modify ?exercise2 (order 1))
)

; Pull day has a special order assignment 
(defrule assign-next-order-pull-day
   ;; Match a day
   ?day <- (day (name ?dname) (focus pull))

   ;; Find the last assigned back exercise for this day (highest order)
   ?last <- (exercise-slot (day ?dname) (primary-muscle-group back) (order ?last-order&~nil) (priority ?last-priority&~nil))
   (not (exercise-slot (day ?dname) (order ?o2&~nil&:(> ?o2 ?last-order))))
   
   ;; Find an unassigned back exercise for this day
   ?unassigned-slot <- (exercise-slot (day ?dname) (order nil) (primary-muscle-group back))
   =>
   ;; Compute next order number
   (bind ?next-order (+ ?last-order 1))
   
   ;; Assign the exercise
   (modify ?unassigned-slot (order ?next-order))
)