# Exercise Recommender Expert System

COMP 474/COMP 6721 Expert System project

This is an expert system that recommends exercises to users based on the user inputs.

In addtion, it supports uncertainty logic in the form of recommendations:

- [Probabilistics Uncertainty] Recommendation if physician consultation is required
- [Possibilistic Uncertainty] Recommendation for working weight for squats, bench press and deadlifts.

## Team Pham-Tran

Members:

- Hoang Thuan Pham (40022992)
- Minh Huy Tran (40263743)

## How to run

First, you need to run the included FuzzyCLIPS executable `fz_clips.exe` in the `system` directory:

```
.\<path-to-fz-clips.exe>

# For example
.\system\fz_clips
```

Then, you need to load the facts and rules:

```
(batch "main.clp")
```

To input user parameters, run:

```
(reset)
(input-all)
```

To output recommendation, run:

```
(output)
```

To run all tests:

```
(reset)
(run-all-tests)
```
