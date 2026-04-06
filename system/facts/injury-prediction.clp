(deftemplate recommendation (slot reason) (slot description))

(deftemplate injury-evidence (slot name))

(deftemplate consultation-required)

(deftemplate injury-explanation (multislot explanations))

(deffacts initial-injury-explanation
    (injury-explanation (explanations))
)