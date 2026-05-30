---
name: quality-check
description: >-
  Runs RuboCop and RSpec for tbt-app based on git changes. Creates missing
  specs, executes them, and fixes lint issues. Use when the user asks for
  quality check, rubocop, lint, tests, spec, 品質チェック, or /quality-check.
disable-model-invocation: true
---

# Quality Check (tbt-app)

## Test framework

This project uses **RSpec** + **request specs**.

- Spec path: `spec/**/*_spec.rb`
- Controller behavior: `spec/requests/*_spec.rb` (not controller specs)
- Helpers: `spec/support/` (`session_helpers.rb`)

## When to run

User asks for quality check, lint, tests, spec, or before commit when requested.

## Workflow

### 1. Inspect changes

```bash
git status
git diff
git diff --staged
```

Identify changed files under `app/`, `config/`, `lib/`, `spec/`.

### 2. Ensure specs exist for changed app code

| Changed file | Expected spec |
|--------------|---------------|
| `app/controllers/sessions_controller.rb` | `spec/requests/sessions_spec.rb` |
| `app/controllers/registrations_controller.rb` | `spec/requests/registrations_spec.rb` |
| `app/models/user.rb` | `spec/models/user_spec.rb` |

If spec file is missing, **create it** following existing patterns:

- **Spec descriptions are in Japanese** (`describe` / `it` — match day-job convention)
- Request spec: `type: :request`, `fixtures :users`, `sign_in_as` helper
- Model spec: `type: :model`, test validations and normalizations
- Use `I18n.t(...)` for flash/message assertions
- Mailer jobs: `have_enqueued_mail(Mailer, :action).with(args)`

Read a similar existing spec before writing a new one.

### 3. Run RuboCop

Via Docker:

```bash
docker compose exec web bin/quality --fix   # auto-fix + specs
docker compose exec web bin/quality         # check only
```

Or manually:

```bash
docker compose exec web bin/rubocop path/to/file.rb
docker compose exec web bin/rubocop -A path/to/file.rb
```

**Rules:** `rubocop-rails-omakase` (`.rubocop.yml`). Use `-A` for auto-correctable offenses.

### 4. Run specs

```bash
docker compose exec web bundle exec rspec spec/requests/sessions_spec.rb
docker compose exec web bundle exec rspec
```

If specs fail, fix code or specs until green.

### 5. Full CI locally (optional)

```bash
docker compose exec web bin/ci
```

## Checklist before reporting done

- [ ] Missing specs added for new/changed behavior
- [ ] `bin/rubocop` passes on changed files
- [ ] Targeted specs pass
- [ ] No secrets or unrelated files modified

## Project commands

| Command | Purpose |
|---------|---------|
| `docker compose exec web bin/quality` | RuboCop + targeted specs |
| `docker compose exec web bin/quality --fix` | Same + RuboCop auto-fix |
| `docker compose exec web bin/rubocop` | Lint all files |
| `docker compose exec web bundle exec rspec` | Full spec suite |
| `docker compose exec web bin/ci` | Full local CI |
