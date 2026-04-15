# expert-system

COMP 474/COMP 6721 Expert System project

This is an expert system that recommends exercises to users.

## Team Pham-Tran

Members:

- Hoang Thuan Pham
- Minh Huy Tran

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
