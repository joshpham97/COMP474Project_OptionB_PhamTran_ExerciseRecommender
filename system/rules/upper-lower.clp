(defmodule UPPER-LOWER (import MAIN deftemplate workout-split day exercise-slot user-input muscle-group))

(defrule initialize-upper-lower
   (workout-split (name "Upper-Lower"))
   (not (day))
   =>
   (assert (day (order 1) (name "Upper 1") (focus upper)))
   (assert (day (order 2) (name "Lower 1") (focus lower)))
   (assert (day (order 3) (name "Upper 2") (focus upper)))
   (assert (day (order 4) (name "Lower 2") (focus lower)))
)

(defrule initialize-exercise-slots-upper
   (day (order ?day-order) (focus upper))
   =>
   (assert (exercise-slot (day-order ?day-order) (exercise-order 1) (primary-muscle-group nil)))
   (assert (exercise-slot (day-order ?day-order) (exercise-order 2) (primary-muscle-group nil)))
   (assert (exercise-slot (day-order ?day-order) (exercise-order 3) (primary-muscle-group nil)))
   (assert (exercise-slot (day-order ?day-order) (exercise-order 4) (primary-muscle-group nil)))
   (assert (exercise-slot (day-order ?day-order) (exercise-order 5) (primary-muscle-group shoulder)))
   (assert (exercise-slot (day-order ?day-order) (exercise-order 6) (primary-muscle-group triceps)))
   (assert (exercise-slot (day-order ?day-order) (exercise-order 7) (primary-muscle-group biceps)))
)

(defrule initialize-exercise-slots-lower
   (day (order ?day-order) (focus lower))
   =>
   (assert (exercise-slot (day-order ?day-order) (exercise-order 1) (primary-muscle-group nil)))
   (assert (exercise-slot (day-order ?day-order) (exercise-order 2) (primary-muscle-group nil)))
   (assert (exercise-slot (day-order ?day-order) (exercise-order 3) (primary-muscle-group nil)))
   (assert (exercise-slot (day-order ?day-order) (exercise-order 4) (primary-muscle-group nil)))
   (assert (exercise-slot (day-order ?day-order) (exercise-order 5) (primary-muscle-group glutes)))
   (assert (exercise-slot (day-order ?day-order) (exercise-order 6) (primary-muscle-group calves)))
)

(defrule compute-global-order
   ?s <- (exercise-slot (day-order ?day-order) (exercise-order ?exercise-order))
   =>
   (modify ?s (global-order (+ (* ?day-order 100) ?exercise-order)))
)

(defrule assign-first-slot-muscle-group-by-user-preference
   ?s <- (exercise-slot (day-order ?day-order) (exercise-order 1) (primary-muscle-group nil))
   (day (order ?day-order) (focus ?f))
   (user-input (muscle-group ?mg&~nil))
   (muscle-group (name ?mg) (region ?f))
   =>
   (modify ?s (primary-muscle-group ?mg))
)

(defrule assign-first-slot-muscle-group-upper
   ?s1 <- (exercise-slot (day-order ?order1) (exercise-order 1) (primary-muscle-group nil))
   ?s2 <- (exercise-slot (day-order ?order2) (exercise-order 1) (primary-muscle-group nil))
   (day (order ?order1) (focus upper))
   (day (order ?order2) (focus upper))
   (test (< ?order1 ?order2))
   (muscle-group (name ?mg) (region ?f))
   (user-input (muscle-group nil))
   (and
      (user-input (muscle-group ?mg))
      (muscle-group (name ?mg) (region ?f&~upper))
   )
   =>
   (modify ?s1 (primary-muscle-group chest))
   (modify ?s2 (primary-muscle-group back))
)

(defrule assign-first-slot-muscle-group-lower
   ?s1 <- (exercise-slot (day-order ?order1) (exercise-order 1) (primary-muscle-group nil))
   ?s2 <- (exercise-slot (day-order ?order2) (exercise-order 1) (primary-muscle-group nil))
   (day (order ?order1) (focus lower))
   (day (order ?order2) (focus lower))
   (test (< ?order1 ?order2))
   (and
      (user-input (muscle-group ?mg))
      (muscle-group (name ?mg) (region ?f&~lower))
   )
   =>
   (modify ?s1 (primary-muscle-group quads))
   (modify ?s2 (primary-muscle-group hamstring))
)

(defrule assign-slot-muscle-group-after-chest
   ?s1 <- (exercise-slot (day-order ?day-order) (exercise-order ?ex-order1) (primary-muscle-group chest))
   ?s2 <- (exercise-slot (day-order ?day-order) (exercise-order ?ex-order2) (primary-muscle-group nil))
   (test (= (- ?ex-order2 ?ex-order1) 1))
   =>
   (modify ?s2 (primary-muscle-group back))
)

(defrule assign-slot-muscle-group-after-back
   ?s1 <- (exercise-slot (day-order ?day-order) (exercise-order ?ex-order1) (primary-muscle-group back))
   ?s2 <- (exercise-slot (day-order ?day-order) (exercise-order ?ex-order2) (primary-muscle-group nil))
   (test (= (- ?ex-order2 ?ex-order1) 1))
   =>
   (modify ?s2 (primary-muscle-group chest))
)

(defrule assign-slot-muscle-group-after-quads
   ?s1 <- (exercise-slot (day-order ?day-order) (exercise-order ?ex-order1) (primary-muscle-group quads))
   ?s2 <- (exercise-slot (day-order ?day-order) (exercise-order ?ex-order2) (primary-muscle-group nil))
    (test (= (- ?ex-order2 ?ex-order1) 1))
   =>
   (modify ?s2 (primary-muscle-group hamstring))
)

(defrule assign-slot-muscle-group-after-hamstring
   ?s1 <- (exercise-slot (day-order ?day-order) (exercise-order ?ex-order1) (primary-muscle-group hamstring))
   ?s2 <- (exercise-slot (day-order ?day-order) (exercise-order ?ex-order2) (primary-muscle-group nil))
   (test (= (- ?ex-order2 ?ex-order1) 1))
   =>
   (modify ?s2 (primary-muscle-group quads))
)