; global queue position
(defglobal ?*queue-position* = 0)

(deffunction select-exercise-by-slot (?day ?slot-id)

   ; assert the control fact for this day
   (bind ?*queue-position* (+ ?*queue-position* 1))
   (printout t "Processing exercise slot " ?slot-id " for day " ?day " queue position " ?*queue-position* crlf)
   (assert (to-be-processed (day ?day) (id ?slot-id) (queue-position ?*queue-position*)))
)

(deffunction process-exercise-by-order (?day)
   ; find maximum order dynamically for that day only
   (bind ?max 0)

   (do-for-all-facts ((?f exercise-slot))
      (eq ?f:day ?day)

      (if (> ?f:order ?max)
          then (bind ?max ?f:order))
   )

   ; iterate from 1 to max
   (bind ?i 1)

   (while (<= ?i ?max) do

      (do-for-all-facts ((?f exercise-slot))
         (and (eq ?f:day ?day)
              (= ?f:order ?i))

         (select-exercise-by-slot ?f:day ?f:id)
      )

      (bind ?i (+ ?i 1))
   )
)

(deffunction select-exercises-for-day ()
   (do-for-all-facts ((?d day)) 
      TRUE
      (printout t "Day is " ?d:name crlf)
      (process-exercise-by-order ?d:name)
   )
)

(deffunction has-multiple-candidates (?day ?slot)
   (> (length$
        (find-all-facts
           ((?c candidate-exercise))
           (and (eq ?c:day ?day)
                (eq ?c:slot-id ?slot))))
1))

(defrule dequeue
   ?item <- (to-be-processed (day ?day) (id ?slot-id) (queue-position ?pos1))
   (not (to-be-processed (queue-position ?pos2&:(> ?pos1 ?pos2))))
   (not (currently-processing))
   =>
   (assert (currently-processing (day ?day) (id ?slot-id)))
   (retract ?item)
)

(defrule generate-candidate
   (currently-processing (day ?dname) (id ?slot-id))
   (not (candidate-initialized (day ?dname) (slot-id ?slot-id)))
   ?slot <- (exercise-slot 
               (id ?slot-id)
               (day ?dname)
               (primary-muscle-group ?muscle-group)
               (exercise nil))
   ?ex <- (exercise 
               (id ?ex-id) 
               (primary-muscle-group ?muscle-group) 
               (targeted-sub-muscle-group ?sub))
   ?subm <- (sub-muscle-group 
               (main-muscle-group ?muscle-group) 
               (name ?sub) 
               (priority ?priority))
   =>
   (assert (candidate-exercise
               (day ?dname)
               (slot-id ?slot-id)
               (muscle-group ?muscle-group)
               (exercise-id ?ex-id)
               (priority ?priority)))
   
   (printout t "Generate exercise " ?ex-id " for day " ?dname " slot " ?slot-id crlf)
)

(defrule all-candidates-generated-per-slot
   (currently-processing (day ?day) (id ?slot-id))
   ; the slot we are working on
   (exercise-slot 
      (id ?slot-id) 
      (day ?day) 
      (primary-muscle-group ?mg)
      (exercise nil))

   ; make sure there is NO exercise of that muscle group
   ; for which a candidate-exercise does NOT exist
   (not 
      (and
         (exercise (primary-muscle-group ?mg) (id ?ex-id))
         (not (candidate-exercise 
                  (day ?day)
                  (slot-id ?slot-id)
                  (exercise-id ?ex-id)))))
   =>
   (assert (candidate-initialized (day ?day) (slot-id ?slot-id)))
)

(defrule filter-assigned-candidate
   (declare (salience 52))
   (candidate-initialized (day ?d) (slot-id ?slot-id))
   (test (has-multiple-candidates ?d ?slot-id))
   ?c <- (candidate-exercise 
            (day ?d)
            (slot-id ?slot-id)
            (exercise-id ?id))
   (exercise-slot 
      (day ?d)
      (id ?other-slot&~?slot-id)
      (exercise ?id&~nil))

   =>
   (retract ?c)
)

(defrule filter-assigned-candidate-by-sub-muscle-group
   (declare (salience 51))
   (candidate-initialized (day ?d) (slot-id ?slot-id))
   (test (has-multiple-candidates ?d ?slot-id))
   ; Candidate for this slot
   ?c <- (candidate-exercise 
            (day ?d)
            (slot-id ?slot-id)
            (exercise-id ?id))
   (exercise (id ?id) (targeted-sub-muscle-group ?sub))
   (and 
      (exercise-slot 
         (day ?d)
         (id ?other-slot&~?slot-id)
         (exercise ?other-id))
      (exercise (id ?other-id) (targeted-sub-muscle-group ?sub))
   )
   =>
   (retract ?c)
)


(defrule filter-candidate-by-priority
   (declare (salience 49))
   
   (candidate-initialized (day ?d) (slot-id ?slot-id))

   (test (has-multiple-candidates ?d ?slot-id))

   ?c1 <- (candidate-exercise 
              (day ?d)
              (slot-id ?slot-id)
              (exercise-id ?id1)
              (priority ?p1))

   ?c2 <- (candidate-exercise
              (day ?d)
              (slot-id ?slot-id)
              (exercise-id ?id2&~?id1)
              (priority ?p2&:(> ?p2 ?p1)))

   =>
   (retract ?c2)
)

(defrule filter-by-user-preference 
   (declare (salience 48))
   (candidate-initialized (day ?d) (slot-id ?slot-id))
   (test (has-multiple-candidates ?d ?slot-id))
   (user-input (exercise-type ?user-type))
   ?c1 <- (candidate-exercise
            (day ?d)
            (slot-id ?slot-id)
            (exercise-id ?ex-id1)
            (priority ?p))
   (exercise (id ?ex-id1) (equipment ?user-type))
   ?c2 <- (candidate-exercise
            (day ?d)
            (slot-id ?slot-id)
            (exercise-id ?ex-id2)
            (priority ?p))
   (exercise (id ?ex-id2) (equipment ?other-type&~?user-type))

   ;; Ensure no candidate exists for this slot & day with a different movement type
   => 
   (retract ?c2)
)

(defrule filter-candidate-by-movement
   ?to-be-processed <- (to-be-processed (day ?d) (id ?slot-id))
   (candidate-initialized (day ?d) (slot-id ?slot-id))
   (test (has-multiple-candidates ?d ?slot-id))
   ;; Isolation candidate (the one we may retract)
   ?iso <- (candidate-exercise 
               (day ?d)
               (slot-id ?slot-id)
               (muscle-group ?m)
               (exercise-id ?iso-id)
               (priority ?p))

   (exercise (id ?iso-id) (movement isolation))

   ;; Ensure there exists at least one compound candidate with the same priority
   (exists
      (and
         (candidate-exercise
            (day ?d)
            (slot-id ?slot-id)
            (muscle-group ?m)
            (exercise-id ?comp-id&~?iso-id)
            (priority ?p))
         (exercise (id ?comp-id) (movement compound))
      )
   )

   =>
   (retract ?iso)
)

(defrule filter-candidate-random
   ?to-be-processed <- (to-be-processed (day ?d) (id ?slot-id))
   (candidate-initialized (day ?d) (slot-id ?slot-id))
   (test (has-multiple-candidates ?d ?slot-id))
   ;; Candidate 1
   ?c1 <- (candidate-exercise
              (day ?d)
              (slot-id ?slot-id)
              (exercise-id ?id1)
              (priority ?p))
   (exercise (id ?id1) (movement ?move))

   ;; Candidate 2 (different exercise, same slot and day)
   ?c2 <- (candidate-exercise
              (day ?d)
              (slot-id ?slot-id)
              (exercise-id ?id2&~?id1)
              (priority ?p))
   (exercise (id ?id2) (movement ?move))

   ;; Ensure no candidate exists for this slot & day with a different movement type
   (not
      (and
         (candidate-exercise
            (day ?d)
            (slot-id ?slot-id)
            (exercise-id ?other-id&~?id1&~?id2)
         )
         (exercise (id ?other-id) (movement ?other-move&~?move))
      )
   )

   ;; Ensure all candidates for this slot/day have the same priority
   (not
      (candidate-exercise
         (day ?d)
         (slot-id ?slot-id)
         (exercise-id ?other-id&~?id1&~?id2)
         (priority ?other-priority&~?p)
      )
   )

   =>
   (retract ?c2)
)

(defrule select-exercise
   (declare (salience 50))
   ?processing <- (currently-processing (day ?day) (id ?slot-id)) 
   (candidate-initialized (day ?day) (slot-id ?slot-id))
   ?candidate <- (candidate-exercise
            (day ?day)
            (slot-id ?slot-id)
            (exercise-id ?id)
            (priority ?p)
         )
   ?s <- (exercise-slot (day ?day) (id ?slot-id) (order ?current-order))
   ;; There must NOT exist another candidate for the same slot & day
   (not
      (and
         (candidate-exercise
            (day ?day)
            (slot-id ?slot-id)
            (exercise-id ?other-id))
         (eq ?other-id ?id)
      )  
   )
   =>
   (printout t "Assigned exercise for day " ?day " slot " ?slot-id " exercise " ?id  " priority " ?p " order " ?current-order crlf)
   (modify ?s (exercise ?id))
   (retract ?candidate)
   (retract ?processing)
)

(defrule all-exercises-ready
   (not (exercise-slot (order nil)))
   (not (exercise-slot (priority nil)))
   (not (exercise-slot (primary-muscle-group nil)))
   =>
   (select-exercises-for-day)
)