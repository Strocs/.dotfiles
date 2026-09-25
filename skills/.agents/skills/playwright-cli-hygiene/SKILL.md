---
name: playwright-cli-hygiene
description: "Trigger: playwright-cli, browser instance, close browser, pwcli close, session cleanup. Enforce lifecycle hygiene: close every instance the agent opened; ask before closing pre-existing ones."
license: Apache-2.0
metadata:
  author: "strocs"
  version: "1.0"
---

# Skill: playwright-cli-hygiene

## Activation Contract

Load whenever work drives a real browser through `playwright-cli` (or its wrapper) and any lifecycle decision arises: opening, reusing, closing, or managing browser instances and named sessions. Complements the base playwright CLI skill; do not replace it.

## Hard Rules

1. CLOSE WHAT YOU OPENED: every browser instance or named session the agent opened MUST be closed when the work ends (`pwcli close` or `pwcli --session <name> close`). No exceptions.
2. NEVER close an instance or session that pre-existed the agent's work without asking the user first. If the agent only reused it, closing is optional: ask whether it should be closed or kept.
3. Never touch the default session when the user may be using it. Isolate agent work in a named session: `pwcli --session <label> open <url>`.
4. Cleanup applies on failure too: an aborted or failed flow still requires closing agent-opened instances.
5. Verify closure: after closing, confirm no agent-owned session or instance remains. Never close the same instance twice.
6. Use `--headed` only when a visual check genuinely helps; default to headless.
7. Report final state: what was opened, what was closed, what remains open and why.

## Decision Gates

| Who owns the instance or session? | Action |
| --- | --- |
| Agent opened it this work | Close it, no question needed |
| Pre-existing (user or other process) | Ask: close or keep? Never close silently |
| Ownership unknown | Ask: close or keep? |
| User explicitly asked to close | Close it |

## Execution Steps

1. Before starting, record which instances and sessions already exist (`pwcli --session <name> tab-list` or session listing) so ownership is known.
2. Open agent work in its own named session: `pwcli --session <work-label> open <url>` (headless unless a visual check is needed).
3. Work with the base CLI loop: open, snapshot, interact, re-snapshot.
4. On completion (success or failure): close every session or instance the agent opened and verify closure.
5. Ask about pre-existing instances only when closure is relevant; never close them silently.
6. Report the final lifecycle state.

## Output Contract

Return: the sessions and instances the agent opened and closed; any pre-existing instance left open and why; any user decision requested and its outcome.

## References

- `../playwright/SKILL.md` — base playwright CLI skill (wrapper, workflow, guardrails).
- `../playwright/references/cli.md` — `close`, `--session`, and session commands.
- `../playwright/references/workflows.md` — practical flows and troubleshooting.