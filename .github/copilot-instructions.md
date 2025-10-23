## Purpose

This file instructs GitHub Copilot / AI coding agents how to be immediately productive in this repository. The project currently contains no source files. Keep instructions concise and update this file whenever project structure, tooling, or workflows change.

## What to look for first (quick checklist)

- Is there a `package.json`, `pyproject.toml`, `requirements.txt`, `go.mod`, or similar? If yes: use the declared tooling and dependency manager.
- Locate `README.md`, `Makefile`, `Dockerfile`, CI configs (`.github/workflows/*`) for build/test/run steps.
- Check for `src/`, `cmd/`, `app/`, `pkg/`, `internal/`, `tests/` to infer language and layout.

## Minimal agent contract (how to act)

- Inputs: repository files, current branch, active file in editor.
- Outputs: small, focused edits; tests or smoke-run when possible; concise PR or commit message.
- Error modes: missing build/test configs — propose minimal reproducible harness; failing tests — attempt quick fixes or list failing output.

## Patterns & conventions (project is empty — templates)

Since the repo is empty, use these minimal, discoverable templates when scaffolding new projects. Pick the one that matches the user's intent.

- Node.js (minimal): create `package.json`, `src/index.js`, `README.md`, and `npm test` script. Use `npm`/`pnpm` per repo presence.
- Python (minimal): create `pyproject.toml` or `requirements.txt`, `src/` package, and `tests/test_basic.py`. Prefer `pyproject.toml` when creating new projects.
- Go (minimal): create `go.mod`, `cmd/`, `pkg/` and a simple `main.go`.

## When updating this file

- Preserve any existing project-specific notes. If you add build or CI steps, add exact commands (e.g., `pip install -r requirements.txt && pytest`).
- Document any non-standard environment variables, service credentials (do not store secrets), or external APIs used.

## Examples you can add to this file (concrete snippets to record)

- Build & test commands (explicit):

  - Node: `npm install && npm test`
  - Python: `python -m venv .venv && .venv/bin/pip install -r requirements.txt && pytest`
  - Go: `go test ./...`

- Common file references to update when they exist:

  - `README.md` — high level purpose + local run steps
  - `Dockerfile` — how to build and which ports are exposed
  - `.github/workflows/*` — CI steps and test matrix

## Agent best-practices for this repo

- Keep changes minimal and incremental. Prefer adding a small scaffold and README rather than guessing full architecture.
- When asked to implement features, create tests and a README showing how to run them.
- If unsure about language or package manager, create a short list of options and ask the user before proceeding.

## Where to add more detail

- Add notes describing service boundaries, event flows, message brokers, DB types, and auth methods once they exist.
- Add preferred linting, formatting, and CI checks here (ESLint, black, gofmt, etc.).

---

If you'd like, I can scaffold a minimal project (Node/Python/Go) and boilerplate tests now — tell me which stack to use and I'll create files and runnable commands.
# Copilot AI Coding Agent Instructions

This project currently has no source files or documentation. As the codebase evolves, update this file to provide essential context for AI coding agents. For now, follow these guidelines:

- If you add major components, document their purpose and relationships here.
- Note any non-standard build, test, or deployment workflows as they are introduced.
- Record project-specific conventions, naming patterns, or integration points as they emerge.
- Reference key files and directories as they are created.

**Example future structure:**
- `/src/` — main source code
- `/tests/` — test suite
- `/README.md` — project overview and setup

Update this file as the project grows to maximize AI agent productivity.
