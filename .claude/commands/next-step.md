---
description: Commit the approved step, build the next one, show it in the Simulator, explain it, and wait
---

Running this command means the owner approves the current step.

1. **Commit the approved step.** If there are uncommitted changes from the current step, commit them with a clear message. If there's nothing to commit, skip this.
2. **Build the next step** from the approved plan for this issue, and nothing more. If no steps remain, say so, suggest pushing the branch and opening the PR, and stop.
3. **Show it.** Run `xcodegen generate` if files were added or removed, build the app, and launch it in the "MM iPhone 16" simulator with the Simulator panel open. If the step has visible UI, compare it against `docs/design/` and fix clear mismatches before presenting.
4. **Explain the code** in the four-part format from `CLAUDE.md` ("Working through an issue"): in plain terms, SwiftUI you may not know, architecture decisions, and anything else relevant. Keep it concise without leaving anything out.

Then stop. Don't commit this step until the owner approves it, for example by running `/next-step` again.
