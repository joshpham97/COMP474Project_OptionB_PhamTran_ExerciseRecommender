(defmodule ROUTINE-GENERATOR
    (import MAIN deftemplate user-input workout-split exercise-slot muscle-group sub-muscle-group exercise)
)

(defrule assign-full-body
   (user-input (frequency ?f&:(and (neq ?f nil) (= ?f 3))))
   (not  (workout-split))
   =>
   (assert (workout-split (name "Full-body")))
   (focus FULL-BODY)
)

(defrule assign-upper-lower
   (user-input (frequency ?f&:(and (neq ?f nil) (= ?f 4))))
   (not  (workout-split))
   =>
   (assert (workout-split (name "Upper-Lower")))
   (focus UPPER-LOWER)
)

(defrule assign-push-pull-leg
   (user-input (frequency ?f&:(and (neq ?f nil) (= ?f 6))))
   (not  (workout-split))
   =>
   (assert (workout-split (name "Push-Pull-Leg")))
   (focus PUSH-PULL-LEG)
)

(defrule activate-split
   (workout-split (name ?name))
   =>
   (if (eq ?name "Full-body") then (focus FULL-BODY))
   (if (eq ?name "Upper-Lower") then (focus UPPER-LOWER))
   (if (eq ?name "Push-Pull-Leg") then (focus PUSH-PULL-LEG))
)

; Reps determination
(defrule assign-rep-strength
   (user-input (goal strength))
   ?e <- (exercise-slot (min-reps ?r&~1) (max-reps ?r&~5))
   =>
   (modify ?e (min-reps 1) (max-reps 5)))

(defrule assign-rep-hypertrophy
   (user-input (goal hypertrophy))
   ?e <- (exercise-slot (min-reps ?r&~8) (max-reps ?r&~12))
   =>
   (modify ?e (min-reps 8) (max-reps 12)))
(defrule assign-rep-endurance
   (user-input (goal endurance))
   ?e <- (exercise-slot (min-reps ?r&~15) (max-reps ?r&~100))
   =>
   (modify ?e (min-reps 15) (max-reps 100)))

; Set assignment
(defrule assign-set-high-priority
   ?e <- (exercise-slot (primary-muscle-group ?m) (sets 0))
   (muscle-group (name ?m) (priority 1))
   =>
   (modify ?e (sets 3)))
(defrule assign-set-not-high-priority
   ?e <- (exercise-slot (primary-muscle-group ?m) (sets 0))
   (muscle-group (name ?m) (priority ?p&~1))
   =>
   (modify ?e (sets 2))) 

; Determine the global order for each exercises
(defrule compute-global-order
   ?s <- (exercise-slot (day-order ?day-order) (exercise-order ?exercise-order) (global-order nil))
   =>
   (modify ?s (global-order (+ (* ?day-order 100) ?exercise-order)))
)

; Exercise selection
; Sub muscle group selection
(defrule assign-sub-muscle-group-for-first-exercise-by-muscle-group
   (muscle-group (name ?main-mg))
   (sub-muscle-group (main-muscle-group ?main-mg) (name ?sub-mg) (priority 1))
   ?s <- (exercise-slot (global-order ?g-order&~nil)
                        (primary-muscle-group ?main-mg) (targeted-sub-muscle-group nil))
   (not (exercise-slot (primary-muscle-group ?main-mg)
                    (global-order ?g2&~nil&:(< ?g2 ?g-order))))
   =>
   (modify ?s (targeted-sub-muscle-group ?sub-mg))
)

(defrule assign-sub-muscle-group-for-next-exercise-by-muscle-group
   (exercise-slot (global-order ?g-prev&~nil) (primary-muscle-group ?main-mg)
                  (targeted-sub-muscle-group ?prev-smg&~nil))
   (sub-muscle-group (main-muscle-group ?main-mg) (name ?prev-smg) (priority ?prev-p))
   (sub-muscle-group (main-muscle-group ?main-mg) (name ?sub-mg) (priority ?p&:(= ?p (+ ?prev-p 1))))
   ?s <- (exercise-slot (global-order ?g-order&~nil&:(> ?g-order ?g-prev))
                        (primary-muscle-group ?main-mg) (targeted-sub-muscle-group nil))
   (not (exercise-slot (primary-muscle-group ?main-mg)
                       (targeted-sub-muscle-group nil)
                       (global-order ?g2&~nil&:(and (> ?g2 ?g-prev) (< ?g2 ?g-order)))))
   =>
   (modify ?s (targeted-sub-muscle-group ?sub-mg))
)

(defrule assign-sub-muscle-group-loop-back
   (exercise-slot (global-order ?g-prev&~nil) (primary-muscle-group ?main-mg)
                  (targeted-sub-muscle-group ?prev-smg&~nil))
   (sub-muscle-group (main-muscle-group ?main-mg) (name ?prev-smg) (priority ?prev-p))
   ; no sub-muscle-group exists with a higher priority number (i.e. we're at the lowest)
   (not (sub-muscle-group (main-muscle-group ?main-mg) (priority ?next-p&:(= ?next-p (+ ?prev-p 1)))))
   ; loop back to priority 1
   (sub-muscle-group (main-muscle-group ?main-mg) (name ?sub-mg) (priority 1))
   ?s <- (exercise-slot (global-order ?g-order&~nil&:(> ?g-order ?g-prev))
                        (primary-muscle-group ?main-mg) (targeted-sub-muscle-group nil))
   (not (exercise-slot (primary-muscle-group ?main-mg)
                       (targeted-sub-muscle-group nil)
                       (global-order ?g2&~nil&:(and (> ?g2 ?g-prev) (< ?g2 ?g-order)))))
   =>
   (modify ?s (targeted-sub-muscle-group ?sub-mg))
)

(defrule swap-sub-muscle-group-based-on-day-order
   ?s1 <- (exercise-slot (day-order ?day-order) (primary-muscle-group ?main-mg) (targeted-sub-muscle-group ?sub-mg1))
   ?s2 <- (exercise-slot (day-order ?day-order) (primary-muscle-group ?main-mg) (targeted-sub-muscle-group ?sub-mg2))
   (sub-muscle-group (name ?sub-mg1) (priority ?priority1))
   (sub-muscle-group (name ?sub-mg2) (priority ?priority2))
   (test (> ?priority1 ?priority2))
   (test (< (fact-index ?s1) (fact-index ?s2))) ; Making sure that the facts are matched only once. AI prompt: How can I prevent the facts from matching infinitely (22/3/2026)
   =>
   (modify ?s1 (targeted-sub-muscle-group ?sub-mg2))
   (modify ?s2 (targeted-sub-muscle-group ?sub-mg1))
)

; Exercise selection based on user equipment preference and movement type

(defrule assign-exercise-by-user-preference-compound
   (declare (salience 3))
   ?s <- (exercise-slot (targeted-sub-muscle-group ?sub-mg&~nil) (exercise nil))
   (exercise (id ?execise-id) (targeted-sub-muscle-group ?sub-mg) (equipment ?equipment) (movement compound)) ; prioritizing compound movements
   (user-input (exercise-type ?equipment))
   (not (exercise-slot (exercise ?execise-id)))
   =>
   (modify ?s (exercise ?execise-id))
)

(defrule assign-exercise-by-user-preference-isolation
   (declare (salience 2))
   ?s <- (exercise-slot (targeted-sub-muscle-group ?sub-mg&~nil) (exercise nil))
   (exercise (id ?execise-id) (targeted-sub-muscle-group ?sub-mg) (equipment ?equipment) (movement isolation)) ; prioritizing compound movements
   (user-input (exercise-type ?equipment))
   (not (exercise-slot (exercise ?execise-id)))
   => 
   (modify ?s (exercise ?execise-id))
)

(defrule assign-exercise-by-compound
   (declare (salience 1))
   ?s <- (exercise-slot (targeted-sub-muscle-group ?sub-mg&~nil) (exercise nil))
   (exercise (id ?execise-id) (targeted-sub-muscle-group ?sub-mg) (movement compound)) ; prioritizing compound movements
   (not (exercise-slot (exercise ?execise-id)))
   => 
   (modify ?s (exercise ?execise-id))
)

(defrule assign-exercise-by-isolation
   (declare (salience 0))
   ?s <- (exercise-slot (targeted-sub-muscle-group ?sub-mg&~nil) (exercise nil))
   (exercise (id ?execise-id) (targeted-sub-muscle-group ?sub-mg) (movement isolation)) ; prioritizing compound movements
   (not (exercise-slot (exercise ?execise-id)))
   => 
   (modify ?s (exercise ?execise-id))
)

; If there is no exercise that matches the rules above, fire fallback rules
(defrule assign-exercise-fallback
   (declare (salience -1))
   ?s <- (exercise-slot (targeted-sub-muscle-group ?sub-mg&~nil) (exercise nil))
   (exercise (id ?execise-id) (targeted-sub-muscle-group ?sub-mg)) ; prioritizing compound movements
   => 
   (modify ?s (exercise ?execise-id))
)

