(deffacts sub-muscle-groups-data
    (sub-muscle-group (main-muscle-group chest) (name middle-chest) (priority 1))
    (sub-muscle-group (main-muscle-group chest) (name upper-chest) (priority 2))
    (sub-muscle-group (main-muscle-group chest) (name lower-chest) (priority 3))
    
    (sub-muscle-group (main-muscle-group back) (name frontal-plane-lats) (priority 1))
    (sub-muscle-group (main-muscle-group back) (name upper-back) (priority 2))
    (sub-muscle-group (main-muscle-group back) (name sagittal-plane-lats) (priority 3))
    (sub-muscle-group (main-muscle-group back) (name traps) (priority 4))

    (sub-muscle-group (main-muscle-group shoulder) (name front-delt) (priority 1))
    (sub-muscle-group (main-muscle-group shoulder) (name side-delt) (priority 2))
    (sub-muscle-group (main-muscle-group shoulder) (name rear-delt) (priority 3))

    (sub-muscle-group (main-muscle-group biceps) (name long-and-short-head) (priority 1))
    (sub-muscle-group (main-muscle-group biceps) (name branchialis) (priority 3))

    (sub-muscle-group (main-muscle-group triceps) (name lateral-and-medial-head) (priority 1))
    (sub-muscle-group (main-muscle-group triceps) (name long-head) (priority 3))

    (sub-muscle-group (main-muscle-group hamstring) (name lengthened) (priority 1))
    (sub-muscle-group (main-muscle-group hamstring) (name shortened) (priority 2))

    (sub-muscle-group (main-muscle-group glutes) (name gluteus-maximus) (priority 1))
    (sub-muscle-group (main-muscle-group glutes) (name gluteus-medius) (priority 2))

    (sub-muscle-group (main-muscle-group quads) (name quads) (priority 1))

    ; Calves is a special case, there is no sub-muscle groups, so we leave it as is
    (sub-muscle-group (main-muscle-group calves) (name calves) (priority 1))
)