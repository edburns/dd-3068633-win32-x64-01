Invoke skill `shepherd-task-20-create-issues-from-plan` with these inputs:

- CAMPAIGN_ID: 374df380-2c74-49bf-a522-59078f20ee3e
- LESSON_PROPAGATION: off
- REPO: edburns/dd-3068633-win32-x64-01
- BASE_BRANCH: experiment/shepherd-control
- PARENT_ISSUE: 1
- PLAN_DIRECTORY: 1-math-control-remove-before-merge
- PLAN_FILE_NAME: math-tool-ignorance-reduction-plan.md
- QUESTIONS_SECTION: ## Ignorance reduction
- IMPLEMENTATION_SECTION: ## Implementation
- EXPECTED_TASK_COUNT: 2
- BASE_REMOTE: origin
- LOG_DIRECTORY: C:\Users\edburns\workareas\dd-3068633-win32-x64-01-shepherd-control\1-math-control-remove-before-merge\prompts\shepherd-task-20-20260923-1924
- DRAFT_VALIDATOR: C:\Users\edburns\.copilot\plugins\shepherd-task\scripts\validate-stage20-drafts.ps1
- ISSUE_BODY_VERIFIER: C:\Users\edburns\.copilot\plugins\shepherd-task\scripts\verify-github-issue-body.ps1

Fixture pagination response contract (mandatory):

- `gh api ... --paginate --slurp` returns a JSON array of page payloads, so a
  one-page response has the shape `[[{...}]]`, not `[{...}]`.
- Before indexing child issue fields such as `.id`, normalize the response to
  one flat issue array exactly once.
- In Bash, use:
  `jq 'if length == 0 then [] elif all(.[]; type == "array") then add else . end'`.
- In PowerShell, capture the `gh` output and `$LASTEXITCODE` first, then pass
  the complete JSON through the same `jq` normalization before
  `ConvertFrom-Json`.
- Use the normalized flat array for the pre-creation baseline, final child
  count/order checks, and failure reconciliation. Do not apply `add` a second
  time to an already-flat array.