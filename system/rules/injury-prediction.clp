(defmodule INJURY-PREDICTION 
    (import MAIN deftemplate injury-evidence user-input recommendation consultation-required injury-explanation)
)

(deffunction combine-cf (?cf1 ?cf2)
    (+ ?cf1 (* ?cf2 (- 1 ?cf1))) ; cf is designed to always be more than 0
)

(defrule user-has-previous-injury
    (user-input (has-previous-injury yes))
    (not (injury-evidence (name previous-injury)))
    ?ex <- (injury-explanation (explanations $?exp))
    => 
    (assert (injury-evidence (name previous-injury)) CF 0.8)
    (modify ?ex (explanations ?exp "Previous injury is linked with higher future injury rate."))
)

(defrule user-has-no-previous-injury
    (user-input (has-previous-injury no))
    (not (injury-evidence (name previous-injury)))
    => 
    (assert (injury-evidence (name previous-injury)) CF 0.1)
)

; https://pmc.ncbi.nlm.nih.gov/articles/PMC11293657/#:~:text=Result%20of%20regression%20analysis,the%20entire%20set%20of%20findings.
(defrule user-is-adult
    (user-input (age ?age))
    (test (>= ?age 26))
    (test (<= ?age 35))
    (not (injury-evidence (name age)))
    =>
    (assert (injury-evidence (name age)) CF 0.1)
)

(defrule user-is-teenager-and-young-adult
    (user-input (age ?age))
    (test (< ?age 26))
    ?ex <- (injury-explanation (explanations $?exp))
    (not (injury-evidence (name age)))
    =>
    (assert (injury-evidence (name age)) CF 0.6)
    (modify ?ex (explanations ?exp "Young adults statistically account for a large proportion of gym injuries."))
)

(defrule user-is-elder
    (user-input (age ?age))
    (test (> ?age 35))
    ?ex <- (injury-explanation (explanations $?exp))
    (not (injury-evidence (name age)))
    =>
    (assert (injury-evidence (name age)) CF 0.4)
    (modify ?ex (explanations ?exp "Older adults are more likely to injury themselves due to losing muscle mass and reduced strength."))
)

(defrule user-has-no-strength-training-experience
    (user-input (experience no))
    (not (injury-evidence (name experience)))
    ?ex <- (injury-explanation (explanations $?exp))
    =>
    (assert (injury-evidence (name experience)) CF 0.4)
    (modify ?ex (explanations ?exp "Beginners with no experience are more likely to injure themselves due to poor techniques and forms."))
)

(defrule user-has-strength-training-experience
    (user-input (experience yes))
    (not (injury-evidence (name experience)))
    =>
    (assert (injury-evidence (name experience)) CF 0.1)
)

(defrule user-perfer-free-weight
    (user-input (exercise-type free-weight))
    (not (injury-evidence (name exercise-type)))
    =>
    (assert (injury-evidence (name exercise-type)) CF 0.4)
)

(defrule user-prefer-machine
    (user-input (exercise-type machine))
    (not (injury-evidence (name exercise-type)))
    =>
    (assert (injury-evidence (name exercise-type)) CF 0.1)
)

; Fuzzy CLIPS calculation
; i.e., if the fact does not exist already then the certainty will be as specified in the
; assert and if it does exist the certainty will be modified to be the maximum of the existing 
; certainty and the certainty specified in the assert
(defrule assess-injury-risk
    ?p1 <- (injury-evidence (name previous-injury))
    ?p2 <- (injury-evidence (name age))
    ?p3 <- (injury-evidence (name experience))
    ?p4 <- (injury-evidence (name exercise-type))
    =>
    (bind ?cf1 (get-cf ?p1))
    (bind ?cf2 (get-cf ?p2))
    (bind ?cf3 (get-cf ?p3))
    (bind ?cf4 (get-cf ?p4))
    (bind ?combined (combine-cf ?cf1 ?cf2))
    (bind ?combined (combine-cf ?combined ?cf3))
    (bind ?combined (combine-cf ?combined ?cf4))
    ;(printout t "assess-injury-risk fired" ?combined crlf)
    ; Turn off Fuzzy Clips automated calculation else the CF of all predictors will be considered in the calculation of the assessment
    (disable-rule-cf-calculation)
    (assert (consultation-required) CF ?combined)
    ; Turn it back on
    (enable-rule-cf-calculation)
)

(defrule high-injury-risk
    ?r <- (consultation-required)
    (test (>= (get-cf ?r) 0.8))
    =>
    (assert (recommendation (reason "High injury risk") (description "Consult a physician or personal trainer before starting the program due to high injury risk")))
)


