---
name: astro-react-islands
description: "Trigger: astro react, react in astro, astro islands, client:load, client:only, astro + react. Enforce static-first islands: atomic React client islands, no monolithic wrappers, state via project-detected stores."
license: MIT
metadata:
  author: "strocs"
  version: "1.0"
---

# Astro React Islands

## Activation Contract

Load this skill when:
- Creating or modifying React components in an Astro project
- Adding `client:*` directives to any framework component
- User asks about Astro + React integration, interactivity, or hydration
- Reviewing code that mixes `.astro` and `.jsx`/`.tsx` files

## Hard Rules

- **Astro owns the static shell.** Layout, wrappers, text, images, and non-interactive markup stay in `.astro` components.
- **React handles ONLY interactivity.** Every `client:*` directive requires a justified interactive need (state changes, event handlers, DOM manipulation, real-time updates).
- **No monolithic React wrappers.** Never wrap an entire feature tree in a single `client:load` React component. This defeats islands architecture and ships unnecessary JavaScript.
- **Islands are atomic.** Each React island has ONE interactive responsibility. Split compound features into independent islands.
- **Detect, don't dictate state stores.** Check `package.json` for existing state management (`zustand`, `nanostores`, `jotai`, `valtio`, `@reduxjs/toolkit`, `mobx`, `recoil`, `xstate`). Use what the project already has. If none exists, propose Nanostores (Astro's official recommendation, <1KB, framework-agnostic).
- **Astro `<script>` beats React for simple interactivity.** A click handler, DOM toggle, or event listener that does not need hooks, React state, or cross-component communication belongs in an Astro `<script>` tag — not a React island.

## Decision Gates

Before writing ANY React component, apply these three gates in order:

| Gate | Question | If YES |
|------|----------|--------|
| 1. Static extraction | Can this render as static `.astro` markup? | Keep it in `.astro`. Do NOT add `client:*`. |
| 2. Script sufficiency | Can this be a plain `<script>` in `.astro`? (e.g., DOM toggle, event listener, no hooks needed) | Use `<script>` in `.astro`. Do NOT create a React component. |
| 3. Atomic split | Does this React component do more than ONE interactive thing? | Split into multiple independent islands. Use a state store for cross-island communication if needed. |

Only after ALL THREE gates pass with "NO" — create a focused React island with the most appropriate `client:*` directive.

## Execution Steps

1. **Analyze the feature.** Identify what is static vs. what is interactive. List ALL interactive behaviors.
2. **Exhaust static extraction.** For each behavior, ask: can `.astro` handle this? Can a `<script>` tag handle this?
3. **Design atomic islands.** For remaining interactive behaviors, design one React component per behavior. Each must have a single, clear responsibility.
4. **Detect state store.** Grep `package.json` for `zustand\|nanostores\|jotai\|valtio\|@reduxjs/toolkit\|mobx\|recoil\|xstate`. Use the detected store. If none, propose Nanostores + `@nanostores/react`.
5. **Choose hydration strategy:**
   - `client:load` — critical above-fold interactivity, immediate need
   - `client:visible` — below-fold, defer until component enters viewport
   - `client:idle` — non-critical, hydrate when browser is idle
   - `client:only` — skip SSR entirely (rare; only when component breaks during server render)
   - `client:media` — only on matching media query
6. **Wire cross-island state.** If two atomic islands need shared state, connect them through the detected store. Do NOT create a parent React wrapper to pass props or React context — context does not cross island boundaries.
7. **Verify.** Confirm no static markup leaked into React components. Confirm each `client:*` directive is justified.

## Anti-Pattern — Monolithic Wrapper

```astro
// ❌ BAD: Astro is reduced to a shell. ReactFeature owns everything.
---
import ReactFeature from './ReactFeature';
---
<ReactFeature client:load />
```

Where `ReactFeature` contains layout divs, static text, static images, interactive toggles, forms, and modals — all in one React tree shipped as client JavaScript.

```astro
// ✅ GOOD: Astro owns the layout. React owns only interactive atoms.
---
import Toggle from './Toggle';
import Modal from './Modal';
---
<section>
  <h2>Feature Title</h2>
  <p>Static description text lives in .astro — zero JS shipped.</p>
  <Toggle client:idle />
  <Modal client:visible />
</section>
```

## State Store Detection

Run before proposing any state management:

```bash
grep -oE "zustand|nanostores|jotai|valtio|@reduxjs/toolkit|mobx|recoil|xstate" package.json | head -1
```

- **Match found** — use that store. Wire islands through it. Never force a migration.
- **No match** — propose `nanostores` + `@nanostores/react`.

## Script Over React

When interactivity is simple and self-contained, use `<script>` in `.astro`:

```astro
---
// ✅ Simple toggle — no React needed
---
<button id="menu-toggle">Menu</button>
<nav id="menu" hidden>...</nav>

<script>
  document.getElementById('menu-toggle').addEventListener('click', () => {
    document.getElementById('menu').hidden = !document.getElementById('menu').hidden;
  });
</script>
```

Use React only when the behavior needs: React hooks, React state management, integration with a state store, or composition with other React islands.

## Output Contract

After designing or implementing React components in Astro, report:
1. Each React island created, its `client:*` directive, and its single responsibility.
2. Justification for why each island could NOT be static `.astro` or a `<script>` tag.
3. The detected state store (or proposed Nanostores if none exists).
4. Confirmation that no static markup leaked into React components.

## References

- [Astro Islands Architecture](https://docs.astro.build/en/concepts/islands/)
- [Astro Framework Components](https://docs.astro.build/en/guides/framework-components/)
- [Share State Between Islands](https://docs.astro.build/en/recipes/sharing-state-islands/)
- [Astro Client Directives](https://docs.astro.build/en/reference/directives-reference/#client-directives)
- [Migrate from CRA to Astro](https://docs.astro.build/en/guides/migrate-to-astro/from-create-react-app/)
