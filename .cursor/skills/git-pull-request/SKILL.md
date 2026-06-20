---
name: git-pull-request
description: >-
  Creates GitHub pull requests for tbt-app. Use when the user asks to create a
  PR, open a pull request, push and PR, or says PR作成/PRを作って.
---

# Git Pull Request (tbt-app)

## When to create

Only when the user explicitly asks. Ensure commits exist on a feature branch (see `git-commit` skill).

## Prerequisites

```bash
gh auth status   # if needed: gh auth login
```

Repo: `tbt45/tbt-app`

## Workflow

Run in parallel:

```bash
git status
git branch -vv
git log main..HEAD --oneline
git diff main...HEAD --stat
```

Then:

1. Confirm branch is **not** `main` and working tree is clean (or only intentional uncommitted files).
2. Run `quality-check` skill if not done recently (`docker compose exec -e RAILS_ENV=test web bin/quality`).
3. Push branch:

```bash
git push -u origin HEAD
```

4. Draft PR title and body (see format below). Link issues with `Closes #N`.
5. Create PR:

```bash
gh pr create --title "feat: ..." --body "$(cat <<'EOF'
## Summary
- ...

Closes #N

## Test plan
- [ ] ...
EOF
)"
```

6. Return the PR URL to the user.

Do **not** push to `main` directly or force-push unless the user explicitly asks.

## PR title format

```
feat: Phase N 機能名の短い説明
```

Match commit style from `git-commit` skill. Include issue number in title when helpful: `feat: カロリー管理 (#6)`.

## PR body template

```markdown
## Summary
- 3–5 bullet points (what and why)

Closes #N

## Test plan
- [ ] docker compose exec -e RAILS_ENV=test web bundle exec rspec
- [ ] docker compose exec web bin/quality
- [ ] Manual checks for the feature
```

Use `Closes #N` for sub-issues; reference Epic with `Part of #4` if not closing the epic.

## Phase → issue map

| Phase | Issue | Topic |
|-------|-------|-------|
| 1 | #5 | 体重管理 |
| 1 | #8 | 目標管理 |
| 2 | #6 | カロリー管理 |
| 3 | #7 | 運動 |
| 4 | #9 | ダッシュボード |
| 5 | #10 | レスポンシブ |

Fetch latest details with `github-issues` skill when unsure.

## Safety (never do)

- `git config` changes
- `push --force` to main/master
- Push secrets or `.env` files

## Related skills

| Skill | When |
|-------|------|
| `git-commit` | Commit before PR |
| `quality-check` | Lint + specs before PR |
| `github-issues` | Issue context, epic/phase |

## Quick commands

| Command | Purpose |
|---------|---------|
| `gh pr list --repo tbt45/tbt-app` | Open PRs |
| `gh pr view <N> --repo tbt45/tbt-app` | PR details |
| `gh pr checks <N> --repo tbt45/tbt-app` | CI status |
