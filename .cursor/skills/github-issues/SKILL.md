---
name: github-issues
description: >-
  Fetches GitHub issues and guides feature implementation for tbt-app. Use when
  the user asks about issues, epic, phase, what to implement next, 着手,
  issue確認, or starting health-tracking features.
disable-model-invocation: true
---

# GitHub Issues (tbt-app)

## When to use

- User asks what to implement, which issue to pick, or epic/phase context
- Starting work on health-tracking features (体重・カロリー・運動・目標)
- Writing commits/PRs that should close or reference issues

**Do not** copy issue bodies into chat from memory — always fetch with `gh`.

## Prerequisites

```bash
gh auth status   # if needed: gh auth login
```

Repo: `tbt45/tbt-app`

## Fetch issues

Run in parallel when exploring:

```bash
gh issue list --repo tbt45/tbt-app --state open --label epic
gh issue list --repo tbt45/tbt-app --state open --limit 20
gh issue view <NUMBER> --repo tbt45/tbt-app
```

Filter by phase:

```bash
gh issue list --repo tbt45/tbt-app --label phase-1 --state open
gh issue list --repo tbt45/tbt-app --label phase-2 --state open
```

## Issue map (health-tracking epic)

Always confirm numbers with `gh issue list` — they may change.

| # | Title | Phase | Label |
|---|-------|-------|-------|
| 4 | [Epic] 健康管理メイン機能 | — | `epic` |
| 8 | [Phase 1] 目標管理 | 1 | `phase-1` |
| 5 | [Phase 1] 体重管理 | 1 | `phase-1` |
| 6 | [Phase 2] カロリー管理 | 2 | `phase-2` |
| 7 | [Phase 3] 運動記録 | 3 | `phase-3` |
| 9 | [Phase 4] ダッシュボード・グラフ・カレンダー | 4 | `phase-4` |
| 10 | [Phase 5] レスポンシブ / モバイル対応 | 5 | `phase-5` |

### Recommended implementation order

1. **Phase 1**: #8 目標 → #5 体重（または並行）
2. **Phase 2**: #6 カロリー
3. **Phase 3**: #7 運動
4. **Phase 4**: #9 ダッシュボード
5. **Phase 5**: #10 レスポンシブ

Epic #4 tracks overall progress — check its checklist after sub-issues move.

## Before implementing

1. `gh issue view <NUMBER>` — read 目的・データモデル案・機能要件・テスト
2. Confirm dependencies (e.g. Phase 4 needs Phase 1–3)
3. If scope is unclear, ask the user which issue to tackle

## Implementation conventions (from epic)

- **Auth**: all records scoped to `Current.user`
- **Dates**: `recorded_on` (date), not datetime
- **i18n**: Japanese default (`config.i18n.default_locale = :ja`)
- **Tests**: RSpec request specs, Japanese `describe`/`it` — see `quality-check` skill
- **UI**: Hotwire + Tailwind; charts via Chart.js (importmap) in Phase 4
- **Dev**: `docker compose exec web …` for rails/rspec/migrate

## During / after implementation

### Commits

Reference the issue in the body when useful:

```
feat: add weight entry CRUD

Implement Phase 1 weight tracking. Closes #5.
```

Types follow `git-commit` skill (`feat`, `fix`, `test`, …).

### Pull requests

```bash
gh pr create --title "feat: 体重管理 CRUD (#5)" --body "$(cat <<'EOF'
## Summary
- Weight entry model and CRUD
- Request specs

Closes #5

## Test plan
- [ ] docker compose exec web bundle exec rspec
- [ ] docker compose exec web bin/quality
EOF
)"
```

Use `Closes #N` so merging auto-closes the issue.

### Quality gate

Before marking done, run `quality-check` skill (`bin/quality` or `bin/ci`).

## Updating epic progress

After closing a sub-issue, optionally remind the user to check off the item on Epic #4.

```bash
gh issue view 4 --repo tbt45/tbt-app
```

Manual checkbox update on GitHub is fine; do not edit issues unless the user asks.

## Quick commands

| Command | Purpose |
|---------|---------|
| `gh issue list --label phase-1` | Open Phase 1 issues |
| `gh issue view 5` | Weight management details |
| `gh issue view 4` | Epic overview |
| `gh pr list` | Open PRs |
