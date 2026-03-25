(defmodule FULL-BODY (import MAIN deftemplate workout-split day exercise-slot user-input muscle-group))


; Initial full body workout split
(defrule initialize-full-body
   (workout-split (name "Full-body"))
   (not (day))
   =>
   (assert (day (order 1) (name "Day 1") (focus full-body)))
   (assert (day (order 2) (name "Day 2") (focus full-body)))
   (assert (day (order 3) (name "Day 3") (focus full-body)))
)

(defrule initialize-exercise-slots-full-body
   (day (order ?day-order) (focus full-body))
    =>
   (assert (exercise-slot (day-order ?day-order) (exercise-order 1) (primary-muscle-group nil)))
   (assert (exercise-slot (day-order ?day-order) (exercise-order 2) (primary-muscle-group nil)))
   (assert (exercise-slot (day-order ?day-order) (exercise-order 3) (primary-muscle-group nil)))
   (assert (exercise-slot (day-order ?day-order) (exercise-order 4) (primary-muscle-group nil)))
   (assert (exercise-slot (day-order ?day-order) (exercise-order 5) (primary-muscle-group nil)))
   (assert (exercise-slot (day-order ?day-order) (exercise-order 6) (primary-muscle-group triceps)))
   (assert (exercise-slot (day-order ?day-order) (exercise-order 7) (primary-muscle-group biceps)))
)

(defrule compute-global-order
   ?s <- (exercise-slot (day-order ?day-order) (exercise-order ?exercise-order))
   =>
   (modify ?s (global-order (+ (* ?day-order 100) ?exercise-order)))
)

;  Make the first exercise user preference, leg is set to quads by default if leg is chosen, and if the user preference is not leg, then we assign that muscle group to the first slot

(defrule assign-first-slot-full-body-leg
   (day (order ?d) (focus full-body))
   (user-input (muscle-group legs)) 
   ?s <- (exercise-slot (day-order ?d) (exercise-order 1) (primary-muscle-group nil))
   =>
   (modify ?s (primary-muscle-group quads))
)

(defrule assign-first-slot-full-body
   (day (order ?d) (focus full-body))
   (user-input (muscle-group ?mg&~leg))
   ?s <- (exercise-slot (day-order ?d) (exercise-order 1) (primary-muscle-group nil))
   =>
   (modify ?s (primary-muscle-group ?mg))
)

; For the remaining slots, we assign muscle groups based on the first exercise, and it follows a cycle 
; chest → calves
; calves → back
; back → hamstring
; hamstring → shoulder
; shoulder → glutes
; glutes → chest
; quads → back

(defrule assign-slot-after-chest-full-body
   ?s1 <- (exercise-slot (day-order ?day-order) (exercise-order ?ex-order1) (primary-muscle-group chest))
   ?s2 <- (exercise-slot (day-order ?day-order) (exercise-order ?ex-order2) (primary-muscle-group nil))
   (day (order ?day-order) (focus full-body))
   (test (= (- ?ex-order2 ?ex-order1) 1))
   (test (< ?ex-order2 6))
   =>
   (modify ?s2 (primary-muscle-group calves))
)

(defrule assign-slot-after-calves-full-body
   ?s1 <- (exercise-slot (day-order ?day-order) (exercise-order ?ex-order1) (primary-muscle-group calves))
   ?s2 <- (exercise-slot (day-order ?day-order) (exercise-order ?ex-order2) (primary-muscle-group nil))
   (day (order ?day-order) (focus full-body))
   (test (= (- ?ex-order2 ?ex-order1) 1))
   (test (< ?ex-order2 6))
   =>
   (modify ?s2 (primary-muscle-group back))
)

(defrule assign-slot-after-back-full-body
   ?s1 <- (exercise-slot (day-order ?day-order) (exercise-order ?ex-order1) (primary-muscle-group back))
   ?s2 <- (exercise-slot (day-order ?day-order) (exercise-order ?ex-order2) (primary-muscle-group nil))
   (day (order ?day-order) (focus full-body))
   (test (= (- ?ex-order2 ?ex-order1) 1))
   (test (< ?ex-order2 6))
   =>
   (modify ?s2 (primary-muscle-group hamstring))
)

(defrule assign-slot-after-hamstring-full-body
   ?s1 <- (exercise-slot (day-order ?day-order) (exercise-order ?ex-order1) (primary-muscle-group hamstring))
   ?s2 <- (exercise-slot (day-order ?day-order) (exercise-order ?ex-order2) (primary-muscle-group nil))
   (day (order ?day-order) (focus full-body))
   (test (= (- ?ex-order2 ?ex-order1) 1))
   (test (< ?ex-order2 6))
   =>
   (modify ?s2 (primary-muscle-group shoulder))
)

(defrule assign-slot-after-shoulder-full-body
   ?s1 <- (exercise-slot (day-order ?day-order) (exercise-order ?ex-order1) (primary-muscle-group shoulder))
   ?s2 <- (exercise-slot (day-order ?day-order) (exercise-order ?ex-order2) (primary-muscle-group nil))
   (day (order ?day-order) (focus full-body))
   (test (= (- ?ex-order2 ?ex-order1) 1))
   (test (< ?ex-order2 6))
   =>
   (modify ?s2 (primary-muscle-group quads))
)

(defrule assign-slot-after-quads-full-body
   ?s1 <- (exercise-slot (day-order ?day-order) (exercise-order ?ex-order1) (primary-muscle-group quads))
   ?s2 <- (exercise-slot (day-order ?day-order) (exercise-order ?ex-order2) (primary-muscle-group nil))
   (day (order ?day-order) (focus full-body))
   (test (= (- ?ex-order2 ?ex-order1) 1))
   (test (< ?ex-order2 6))
   =>
   (modify ?s2 (primary-muscle-group chest))
)