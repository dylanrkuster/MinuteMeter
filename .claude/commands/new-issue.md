---
description: Plan a new issue, create it on GitHub, branch off main, and propose a stepped plan
argument-hint: <what to build>
---

Start a new issue for: $ARGUMENTS

1. Make sure the working tree is clean, then check out `main` and pull the latest.
2. Plan internally: read `CLAUDE.md`, `docs/architecture.md`, `docs/design/`, and any code the work touches. The internal plan can be as long as needed.
3. Create the GitHub issue using `.github/ISSUE_TEMPLATE/feature.md` (goal, scope, acceptance criteria, out of scope).
4. Branch off `main` as `<issue number>-<short-slug>`.
5. Propose the simplest, most concise version of the plan: tiny, bite-sized steps that will each be one commit.

Then stop. Take no further action until the owner approves the plan.
