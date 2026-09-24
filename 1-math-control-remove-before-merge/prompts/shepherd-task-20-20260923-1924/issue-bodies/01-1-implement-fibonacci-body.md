## Campaign context and required reading

**On the `experiment/shepherd-control` branch, the directory `1-math-control-remove-before-merge` contains the plan (`math-tool-ignorance-reduction-plan.md`) and supporting resources (diagrams, decision records). Spike subdirectories are research artifacts — read the plan's Resolution sections for findings, not the spike source code.**

Before working, read the entire plan. Then carefully re-read these exact sections:

- `## Ignorance reduction`
- `### Repository-owned validation`
- `### Output and ordering contracts`
- `## Implementation`
- `### 1. Implement Fibonacci with unit and isolated CLI coverage`

The resolved acceptance environment is the committed command `pwsh -NoLogo -NoProfile -File ./eng/test-math-tool.ps1`. The baseline workflow `.github/workflows/shepherd-task-math-tool.yml` installs exactly Pester 5.7.1 and invokes that repository-owned runner; do not replace or bypass it.

The resolved observable contract is that direct CLI execution writes exactly one result line to stdout in the form `Fibonacci(N) = value`, while functions return only the numeric value with no incidental output. Inputs are non-negative integers. The production and test files are repository-root `math-tool.ps1` and `math-tool.Tests.ps1`.

Research for this campaign established no additional spike-specific implementation pattern beyond those resolutions. Implement production behavior from the specification and repository conventions; do not read, copy, or adapt spike source code.

## Branch and execution order

Use `experiment/shepherd-control` as the base branch for this task. Do not target `main`.

This is implementation task 1 of 2. The tasks are assigned, completed, and merged serially in plan order. Do not begin until this issue is assigned. Task 2 must not begin until this task is merged into the base branch. Leave the issue unassigned until the campaign owner dispatches it.

## Implement

Create repository-root `math-tool.ps1` with:

- A script parameter named `N` accepting non-negative integer input.
- A pure `Get-Fibonacci` function that returns the numeric Fibonacci value and emits no incidental output.
- Direct-execution behavior that prints exactly one stdout line: `Fibonacci(N) = value`.
- Correct behavior for `N=0`, `N=1`, and representative small non-negative values.

Create repository-root `math-tool.Tests.ps1` with:

- Dot-sourced unit coverage of `Get-Fibonacci`.
- Isolated child-`pwsh` process coverage of direct CLI behavior so tests distinguish function return behavior from script stdout behavior.
- Explicit coverage for `N=0`, `N=1`, and at least one representative small value.
- Assertions that the CLI output contains exactly the required single result line, with no diagnostic or incidental output.

Follow the repository's existing PowerShell style and deterministic Pester setup. Keep the implementation objective and small.

## Completion gates

- Run the canonical acceptance command exactly: `pwsh -NoLogo -NoProfile -File ./eng/test-math-tool.ps1`.
- The command must exit zero using the repository-pinned Pester 5.7.1 environment.
- Unit tests must prove `Get-Fibonacci` returns numeric values without incidental output for `0`, `1`, and a representative small input.
- Isolated child-process tests must prove direct execution emits exactly `Fibonacci(N) = value` as one stdout line for those inputs.
- The pinned pull-request CI must pass.
- Confirm the PR targets `experiment/shepherd-control` and changes only the math tool and its tests.

## Out of scope

- Factorial support, an operation selector, or any dispatch mechanism; those belong to task 2.
- Replacing, bypassing, or broadening the repository-owned test runner or changing the pinned Pester version.
- Changes outside `math-tool.ps1` and `math-tool.Tests.ps1`.
- Reading or transplanting any spike source code, spike identifiers, or spike test infrastructure.
