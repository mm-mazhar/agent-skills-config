# Prompt â€” Set up git branch & commit policy for a Next.js project (pnpm)

You are a senior Next.js/TypeScript engineer. Set up the git workflow policy (branch
naming, commit messages, local hooks, CI gates) in the current **standalone Next.js
repository** (not a monorepo). The conventions mirror the ChatbotX repo. Create/modify
only the files listed below, run the listed commands, and finish with the verification
checklist. Report every file you created or changed.

## 0. Assumptions

- Package manager: **pnpm** (set `"packageManager": "pnpm@<latest>"` in `package.json`
  and add `"engines": { "node": ">=22" }`; create `.nvmrc` with the same Node version).
- Default branch is `main`.
- If the repo has no test runner yet, add **vitest** (`pnpm add -D vitest`) and make the
  CI test job match reality; if tests are explicitly out of scope, say so and skip the
  test job rather than adding a failing one.

## 1. Add tooling

```bash
pnpm add -D lefthook ultracite @biomejs/biome typescript
pnpm dlx ultracite init   # creates biome.json and wires deps
```

Ensure `package.json` scripts:

```json
{
  "scripts": {
    "dev": "next dev",
    "build": "next build",
    "start": "next start",
    "lint": "ultracite check",
    "fix": "ultracite fix --unsafe",
    "check-types": "tsc --noEmit",
    "test": "vitest run"
  }
}
```

Update `biome.json` to extend ultracite presets (keep any repo-specific ignores):

```json
{
  "$schema": "./node_modules/@biomejs/biome/configuration_schema.json",
  "formatter": { "enabled": true, "indentStyle": "space" },
  "linter": { "enabled": true, "rules": { "recommended": true } },
  "javascript": {
    "formatter": { "quoteStyle": "double", "semicolons": "asNeeded", "trailingCommas": "all" }
  },
  "extends": ["ultracite/biome/core", "ultracite/biome/next"]
}
```

## 2. Decide the ONE type gate

Mirror ChatbotX's explicit trade-off â€” exactly one of these must be true, never zero,
never both silently drifting:

- **Option A (ChatbotX-style):** `next.config.ts` sets
  `typescript: { ignoreBuildErrors: true }` and CI's `check-types` job
  (`tsc --noEmit`) is the ONLY type gate. Add a comment in `next.config.ts` saying the
  CI job must never be removed without re-enabling build-time type-checking.
- **Option B (safer default):** leave `next build` type-checking enabled and use CI's
  type job as a fast pre-check.

Pick one, state the choice in your report, and configure accordingly.

## 3. Create `lefthook.yml` (repo root)

```yaml
post-checkout:
  jobs:
    - name: branch-name
      run: |
        BRANCH=$(git symbolic-ref --short HEAD 2>/dev/null)
        PATTERN='^(feat|fix|bugfix|refactor|docs|style|test|chore|ci|perf|build|revert)/.+'
        # Skip checks for detached HEAD, main, master, develop, release, and bot branches
        if echo "$BRANCH" | grep -qE '^(main|master|develop|HEAD|release/.+|dependabot/.+|renovate/.+)$'; then
          exit 0
        fi
        if ! echo "$BRANCH" | grep -qE "$PATTERN"; then
          echo "Invalid branch name: '$BRANCH'"
          echo ""
          echo "Expected: <type>/<description>"
          echo "  Types: feat, fix, bugfix, refactor, docs, style, test, chore, ci, perf, build, revert"
          echo "  Example: feat/instagram-channel"
          echo "  Example: fix/whatsapp-webhook"
          echo ""
          echo "Rename it with: git branch -m <new-name>"
          exit 1
        fi

pre-commit:
  jobs:
    - run: pnpm ultracite fix
      glob: "*.{js,ts,cjs,mjs,d.cts,d.mts,jsx,tsx,json,jsonc}"
      stage_fixed: true
    - name: typecheck
      run: pnpm check-types
      glob: "**/*.{ts,tsx}"

commit-msg:
  jobs:
    - run: |
        MSG=$(cat {1})
        PATTERN='^(feat|fix|bugfix|refactor|docs|style|test|chore|ci|perf|build|revert)(\(.+\))?!?: .{1,100}$'
        if ! echo "$MSG" | grep -qE "$PATTERN"; then
          echo "Invalid commit message format."
          echo ""
          echo "Expected: <type>(<scope>): <subject>"
          echo "  Types: feat, fix, bugfix, refactor, docs, style, test, chore, ci, perf, build, revert"
          echo "  Append ! before the colon to mark a breaking change: feat(auth)!: remove legacy login"
          echo "  Example: feat(auth): add OAuth2 login"
          echo ""
          echo "Got: $MSG"
          exit 1
        fi
```

Install hooks:

```bash
pnpm exec lefthook install
```

The npm distribution of lefthook auto-installs hooks on `pnpm install`; if it doesn't
in this setup, add `"postinstall": "lefthook install"` to `package.json` so every
contributor gets hooks after a fresh clone.

## 4. Create `.agents/rules/git.md` (canonical human-readable rules)

Use the same document as the Python prompt (commit format + types, branch naming with
the same exemptions, never commit to `main`, never `git add -A`/`--no-verify`/secrets,
PR title = commit format + issue reference, run `pnpm lint` and `pnpm check-types`
before opening a PR, update `CHANGELOG.md` on release tags). Copy it verbatim with the
commands swapped for `pnpm lint` / `pnpm --filter ... check-types` -> `pnpm check-types`.
## 5. Create `.github/workflows/ci.yml`

```yaml
name: CI

on:
  pull_request:
  push:
    branches: [main]

permissions:
  contents: read

concurrency:
  group: ci-${{ github.ref }}
  cancel-in-progress: true

jobs:
  check-types:
    name: Types
    runs-on: ubuntu-latest
    timeout-minutes: 15
    steps:
      - uses: actions/checkout@v7
      # Version comes from packageManager in package.json
      - uses: pnpm/action-setup@v6
      - uses: actions/setup-node@v7
        with:
          node-version: 24
          cache: pnpm
      - run: pnpm install --frozen-lockfile
      - run: pnpm check-types

  lint:
    name: Lint
    runs-on: ubuntu-latest
    timeout-minutes: 15
    steps:
      - uses: actions/checkout@v7
      - uses: pnpm/action-setup@v6
      - uses: actions/setup-node@v7
        with:
          node-version: 24
          cache: pnpm
      - run: pnpm install --frozen-lockfile
      - run: pnpm lint

  test:
    name: Tests
    runs-on: ubuntu-latest
    timeout-minutes: 15
    steps:
      - uses: actions/checkout@v7
      - uses: pnpm/action-setup@v6
      - uses: actions/setup-node@v7
        with:
          node-version: 24
          cache: pnpm
      - run: pnpm install --frozen-lockfile
      - run: pnpm test
```

If tests are out of scope (see §0), omit the `test` job and say so.

## 6. Create `.github/workflows/pr-labeler.yml`

Same as ChatbotX: `pull_request_target (opened, edited, reopened)`, `actions/github-script`,
and the exact `TYPE_MAP` from ChatbotX's `.github/workflows/pr-labeler.yml`
(`feat` -> feature, `fix|bugfix` -> bug, `refactor|perf` -> improvement, `!` variants add
`breaking-change`, plus docs/chore/ci/security/deps mappings). Labels are bootstrapped
once in repo settings; the workflow only applies them.

## 7. Create `.github/dependabot.yml`

```yaml
version: 2
updates:
  - package-ecosystem: "npm"
    directory: "/"
    schedule:
      interval: "weekly"
    open-pull-requests-limit: 10
    groups:
      dev-dependencies:
        dependency-type: "development"
        update-types: ["minor", "patch"]
      production-minor-patch:
        dependency-type: "production"
        update-types: ["minor", "patch"]
    commit-message:
      prefix: "chore(deps)"
      prefix-development: "chore(deps-dev)"

  - package-ecosystem: "github-actions"
    directory: "/"
    schedule:
      interval: "weekly"
    commit-message:
      prefix: "chore(ci)"
```

If the app is Dockerized (`output: "standalone"` + Dockerfile), also add a `docker`
ecosystem entry per Dockerfile directory with Node major bumps ignored (mirror
ChatbotX's rationale comments).

## 8. Optional: release workflow

If the app is deployed as a Docker image, create `.github/workflows/release.yml`
mirroring ChatbotX's: trigger on `push: branches: [main]` + `tags: ["v*"]`, build with
`docker/build-push-action` and per-leg GHA cache scopes. If deployed to Vercel, skip
this file and note that deploys are platform-managed. Either way add
`.github/release.yml` (changelog categories) and a `CHANGELOG.md` skeleton.

## 9. Branch protection (document, don't execute)

README note: protect `main` — require PRs, require the `Types` / `Lint` / `Tests`
checks, dismiss stale approvals, no force-push. GitHub settings task, not a file.

## 10. Verification checklist (run all of these)

1. `pnpm exec lefthook install` succeeds; hooks exist in `.git/hooks`.
2. `git checkout -b "bad_branch_name"` -> rejected. `git branch -m feat/policy-setup` -> accepted.
3. `git commit --allow-empty -m "bad message"` -> rejected by commit-msg hook.
4. `git commit --allow-empty -m "feat: valid message"` -> passes.
5. Add a badly formatted `.tsx` file, stage it, commit -> `ultracite fix` auto-fixes and
   restages it; `pnpm check-types` runs.
6. `pnpm lint && pnpm check-types && pnpm test` pass locally.
7. Push the branch and open a draft PR to confirm CI turns green, then report.
