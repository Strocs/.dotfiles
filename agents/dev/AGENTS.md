# Termux Agent Instructions

## Astro compatibility runtime

Apply these rules only to Astro projects that cannot run with native Termux/Android dependencies:

- Run Node.js tooling through Ubuntu with `ubu run <command>`, for example `ubu run pnpm dev`, `ubu run pnpm check`, and `ubu run pnpm build`.
- Treat `/workspace` inside Ubuntu and the current Termux project as the same files; never clone or synchronize a second copy.
- Once dependencies are installed through `ubu`, do not run package managers, linters, formatters, tests, or builds with the native Termux Node.js runtime.
- Use native Termux commands normally for other projects and for Astro projects without an observed platform incompatibility.
