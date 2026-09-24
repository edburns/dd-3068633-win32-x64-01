## Campaign context and required reading

**On the `experiment/shepherd-control` branch, the directory `1-math-control-remove-before-merge` contains the plan (`math-tool-ignorance-reduction-plan.md`) and supporting resources (diagrams, decision records). Spike subdirectories are research artifacts — read the plan's Resolution sections for findings, not the spike source code.**

Before working, read the entire plan. Then carefully re-read these exact sections:

- `## Ignorance reduction`
- `### Repository-owned validation`
- `### Output and ordering contracts`
- `## Implementation`
- `### 1. Implement Fibonacci with unit and isolated CLI coverage`
- `### 2. Add factorial and operation dispatch`

The resolved acceptance environment is the committed command `pwsh -NoLogo -NoProfile -File ./eng/test-math-tool.ps1`. The baseline workflow `.github/workflows/shepherd-task-math-tool.yml` installs exactly Pester 5.7.1 and invokes that repository-owned runner; do not replace or bypass it.

The resolved observable contract is that direct CLI execution writes exactly one result line to stdout: `Fibonacci(N) = value` or `Factorial(N) = value`. Functions return only numeric values with no incidental output. Inputs are non-negative integers. The production and test files remain repository-root `math-tool.ps1` and `math-tool.Tests.ps1`. This task depends on task 1 already being merged and must preserve its Fibonacci behavior.

Research for this campaign established no additional spike-specific implementation pattern beyond those resolutions. Implement production behavior from the specification and repository conventions; do not read, copy, or adapt spike source code.

## Branch and execution order

Use `experiment/shepherd-control` as the base branch for this task. Do not target `main`.

This is implementation task 2 of 2. The tasks are assigned, completed, and merged serially in plan order. Do not begin until this issue is assigned and task 1 has been merged into the base branch. Start from the merged task 1 state; do not recreate or discard its implementation.

## Implement

Extend repository-root `math-tool.ps1` with:

- A pure `Get-Factorial` function that returns the numeric factorial value and emits no incidental output.
- An `Operation` parameter that dispatches between `fibonacci` and `factorial` while retaining the existing `N` parameter.
- Direct-execution behavior that prints exactly one stdout line matching the selected operation: `Fibonacci(N) = value` or `Factorial(N) = value`.
- Correct factorial behavior for `N=0`, `N=1`, and representative small non-negative values.
- Full preservation of the Fibonacci function and direct CLI behavior delivered by task 1.

Extend repository-root `math-tool.Tests.ps1` with focused production tests. The issue intentionally does not prescribe the internal organization of those extensions, but the resulting suite must independently exercise pure function behavior and isolated direct CLI dispatch behavior.

## Completion gates

- Run the canonical acceptance command exactly: `pwsh -NoLogo -NoProfile -File ./eng/test-math-tool.ps1`.
- The combined regression command must exit zero using the repository-pinned Pester 5.7.1 environment.
- Unit coverage must prove `Get-Factorial` returns numeric values without incidental output for `0`, `1`, and at least one representative small input.
- Existing Fibonacci unit and isolated CLI cases must continue to pass unchanged in observable behavior.
- Isolated child-process coverage must exercise both operation values and prove each invocation emits exactly one correctly labeled result line.
- Add a discriminating dispatch test using the same `N` for both operations where Fibonacci and factorial yield different results, preventing an implementation that ignores `Operation`.
- The pinned pull-request CI must pass.
- Confirm the PR targets `experiment/shepherd-control` and limits changes to the existing math tool and its tests.

## Out of scope

- Additional mathematical operations, interactive input, formatting options, negative-number semantics, or unrelated refactoring.
- Replacing, bypassing, or broadening the repository-owned test runner or changing the pinned Pester version.
- Changes outside `math-tool.ps1` and `math-tool.Tests.ps1`.
- Reading or transplanting any spike source code, spike identifiers, or spike test infrastructure.
