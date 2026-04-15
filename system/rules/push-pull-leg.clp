(defmodule PUSH-PULL-LEG (import MAIN deftemplate workout-split day exercise-slot user-input muscle-group))

(defrule initialize-push-pull-leg
   (workout-split (name "Push-Pull-Leg"))
   (not (day))
   =>
   (assert (day (order 1) (name "Push 1") (focus push)))
   (assert (day (order 2) (name "Pull 1") (focus pull)))
   (assert (day (order 3) (name "Leg 1") (focus leg)))
   (assert (day (order 4) (name "Push 2") (focus push)))
   (assert (day (order 5) (name "Pull 2") (focus pull)))
   (assert (day (order 6) (name "Leg 2") (focus leg)))
)

; Initialize template for each day 
(defrule initialize-exercise-slot-push
   (day (order ?day-order) (focus push))
    =>
   (assert (exercise-slot (day-order ?day-order) (exercise-order 1) (primary-muscle-group nil)))
   (assert (exercise-slot (day-order ?day-order) (exercise-order 2) (primary-muscle-group nil)))
   (assert (exercise-slot (day-order ?day-order) (exercise-order 3) (primary-muscle-group nil)))
   (assert (exercise-slot (day-order ?day-order) (exercise-order 4) (primary-muscle-group nil)))
   (assert (exercise-slot (day-order ?day-order) (exercise-order 5) (primary-muscle-group nil)))
   (assert (exercise-slot (day-order ?day-order) (exercise-order 6) (primary-muscle-group triceps)))
)

(defrule initialize-exercise-slot-pull
   (day (order ?day-order) (focus pull))
    =>
   (assert (exercise-slot (day-order ?day-order) (exercise-order 1) (primary-muscle-group back)))
   (assert (exercise-slot (day-order ?day-order) (exercise-order 2) (primary-muscle-group back)))
   (assert (exercise-slot (day-order ?day-order) (exercise-order 3) (primary-muscle-group back)))
   (assert (exercise-slot (day-order ?day-order) (exercise-order 4) (primary-muscle-group back)))
   (assert (exercise-slot (day-order ?day-order) (exercise-order 5) (primary-muscle-group biceps)))
)

(defrule initialize-exercise-slot-leg
   (day (order ?day-order) (focus leg))
    =>
    (assert(exercise-slot (day-order ?day-order) (exercise-order 1) (primary-muscle-group nil)))
    (assert(exercise-slot (day-order ?day-order) (exercise-order 2) (primary-muscle-group nil)))
    (assert(exercise-slot (day-order ?day-order) (exercise-order 3) (primary-muscle-group nil)))
    (assert(exercise-slot (day-order ?day-order) (exercise-order 4) (primary-muscle-group nil)))
    (assert(exercise-slot (day-order ?day-order) (exercise-order 5) (primary-muscle-group glutes)))
    (assert(exercise-slot (day-order ?day-order) (exercise-order 6) (primary-muscle-group calves)))
)


; Assigning first exercise slot muscle 
(defrule assign-first-slot-user-preference
   ?s <- (exercise-slot (day-order ?order1) (exercise-order 1) (primary-muscle-group nil))
   (day (order ?order1) (focus ?f))
   (user-input (muscle-group ?mg))
   (muscle-group (name ?mg) (type ?f))
   =>
   (modify ?s (primary-muscle-group ?mg))
)

; Assigning first exercise slot muscle fallback when selected muscle group is not fit for the focus of the day
(defrule assign-first-slot-push
   ?s1 <- (exercise-slot (day-order ?order1) (exercise-order 1) (primary-muscle-group nil))
   ?s2 <- (exercise-slot (day-order ?order2) (exercise-order 1) (primary-muscle-group nil))
   (day (order ?order1) (focus push))
   (day (order ?order2) (focus push))
   (user-input (muscle-group ?mg))
   (not (muscle-group (name ?mg) (type push)))
   (test (< ?order1 ?order2))
   =>
   (modify ?s1 (primary-muscle-group chest))
   (modify ?s2 (primary-muscle-group shoulder))
)


(defrule assign-first-slot-leg
   ?s1 <- (exercise-slot (day-order ?order1) (exercise-order 1) (primary-muscle-group nil))
   ?s2 <- (exercise-slot (day-order ?order2) (exercise-order 1) (primary-muscle-group nil))
   (day (order ?order1) (focus leg))
   (day (order ?order2) (focus leg))
   (user-input (muscle-group ?mg))
   (not (muscle-group (name ?mg) (type leg)))
   (test (< ?order1 ?order2))
   =>
   (modify ?s1 (primary-muscle-group quads))
   (modify ?s2 (primary-muscle-group hamstring))
)

; Push alternative shoulder and chest
(defrule assign-slot-after-chest-push
   ?s1 <- (exercise-slot (day-order ?day-order) (exercise-order ?ex-order1) (primary-muscle-group chest))
   ?s2 <- (exercise-slot (day-order ?day-order) (exercise-order ?ex-order2) (primary-muscle-group nil))
   (day (order ?day-order) (focus push))
   (test (= (- ?ex-order2 ?ex-order1) 1))
   =>
   (modify ?s2 (primary-muscle-group shoulder))
)

(defrule assign-slot-after-shoulder-push
   ?s1 <- (exercise-slot (day-order ?day-order) (exercise-order ?ex-order1) (primary-muscle-group shoulder))
   ?s2 <- (exercise-slot (day-order ?day-order) (exercise-order ?ex-order2) (primary-muscle-group nil))
   (day (order ?day-order) (focus push))
   (test (= (- ?ex-order2 ?ex-order1) 1))
   =>
   (modify ?s2 (primary-muscle-group chest))
)

; Leg alternate between hamstring and quads
(defrule assign-slot-after-quads-leg
   ?s1 <- (exercise-slot (day-order ?day-order) (exercise-order ?ex-order1) (primary-muscle-group quads))
   ?s2 <- (exercise-slot (day-order ?day-order) (exercise-order ?ex-order2) (primary-muscle-group nil))
   (day (order ?day-order) (focus leg))
   (test (= (- ?ex-order2 ?ex-order1) 1))
   =>
   (modify ?s2 (primary-muscle-group hamstring))
)

(defrule assign-slot-after-hamstring-leg
   ?s1 <- (exercise-slot (day-order ?day-order) (exercise-order ?ex-order1) (primary-muscle-group hamstring))
   ?s2 <- (exercise-slot (day-order ?day-order) (exercise-order ?ex-order2) (primary-muscle-group nil))
   (day (order ?day-order) (focus leg))
   (test (= (- ?ex-order2 ?ex-order1) 1))
   =>
   (modify ?s2 (primary-muscle-group quads))
)
