---
name: git-commit
description: >-
  Creates git commits for tbt-app following project conventions. Use when the
  user asks to commit, save changes to git, write a commit message, or says
  コミット/commitして.
---

# Git Commit (tbt-app)

## When to commit

Only commit when the user explicitly asks. Do not commit proactively.

## Pre-commit checklist

- [ ] `config/*.key`, `.env`, credentials, tokens are **not** staged
- [ ] `log/`, `tmp/`, `storage/` contents are **not** staged (`.keep` only)
- [ ] Changes match what the user intended to save

## Workflow

Run in parallel:

```bash
git status
git diff
git diff --staged
git log -5 --oneline
```

Then:

1. Stage relevant files (`git add …`). Never stage secrets.
2. Draft a commit message (see format below).
3. Commit with HEREDOC:

```bash
git commit -m "$(cat <<'EOF'
<type>: <subject>

<body (optional, 1-2 sentences why)>
EOF
)"
```

4. Verify with `git status`.

Do **not** push unless the user asks.

## Commit message format

```
<type>: <subject in imperative mood, ≤72 chars>

<optional body: why, not what>
```

### Types

| Type | Use for |
|------|---------|
| `feat` | New feature |
| `fix` | Bug fix |
| `chore` | Tooling, deps, config |
| `docs` | README, comments only |
| `refactor` | Code change without behavior change |
| `test` | Tests only |

### Examples

```
feat: add Task scaffold with CRUD

Enable basic task management as the first app feature.
```

```
chore: update Docker Compose for MySQL healthcheck

Wait for db to be healthy before starting Rails server.
```

```
fix: use DB_PASSWORD env in database.yml for Docker
```

## This project's context

- **Stack**: Rails 8.1, Ruby 4.0.5, MySQL 8.4, Docker, Hotwire
- **Dev**: `docker compose up` — no local Ruby/MySQL required
- **Secrets**: `config/master.key` is gitignored; use credentials or env vars

## Safety (never do)

- `git config` changes
- `push --force` to main/master
- `--no-verify` unless user explicitly requests
- Commit `.env`, `*.key`, or files with API keys/passwords
