# Global Commit Message Guidelines

## Core Philosophy: Granular & Atomic Commits

The primary goal is to create a clean, readable, and understandable git history. This is achieved by creating small, atomic commits. **Prefer creating many small, focused commits over a few large, complex ones.**

## Commit Message Guidelines:

-   **Format:** All commit messages must follow the Conventional Commits specification.
    -   **Prefixes:** `feat`, `fix`, `docs`, `style`, `refactor`, `test`, `chore`.
-   **Subject Line:**
    -   50 characters max.
    -   Start with a capital letter.
    -   Do not end with a period.
    -   Must be a concise summary of the change.
-   **Body:**
    -   **Use only when strictly necessary.** A commit body is only required for complex changes that need further explanation beyond the subject line.
    -   For simple or self-explanatory changes, **do not use a body.**
    -   If used, separate it from the subject with a blank line and wrap at 72 characters.

## Workflow for Creating Commits:

The task of creating and pushing commits starts when I ask you to, and ends when the changes are successfully pushed to the remote repository.

1.  **Analyze Changes:** When I ask you to create commits, first perform a thorough analysis of all staged and unstaged changes (`git diff`).
2.  **Group Logically:** Group the file changes into small, logical, and atomic units. **Unrelated changes must not be in the same commit.** For example, a refactor of one function should be separate from adding a new feature in another part of the code.
3.  **Propose Commit Plan:** Before taking any action, propose a plan to me. For each commit you intend to create, list:
    -   The generated commit message (subject and body, if applicable).
    -   The list of files that will be included in that specific commit.
4.  **Await Approval:** Do not proceed with staging files or creating commits until I approve the plan.
5.  **Execute and Push:** Once the plan is approved, execute the commits as planned and push the changes to the remote repository.

### Confidence Mode

If I explicitly tell you that I trust you, or to use "Confidence Mode", you should skip the approval steps (3 and 4). In this mode, you will:

1.  Analyze the changes.
2.  Generate the commits based on the logical grouping.
3.  Directly execute the commits.
4.  Push the changes to the remote repository without asking for my approval.

---
### Examples

#### Good (Simple Commit, No Body)
```
feat(api): Add health check endpoint
```

#### Good (Complex Commit, With Body)
```
refactor(auth): Switch to JWT for session management

This refactoring replaces the old cookie-based session system with JSON Web Tokens (JWT). This allows for stateless authentication and better scalability.
```

#### Bad (Mixing Concerns)
A single commit that includes:
- Updating the README.
- Fixing a bug in the login form.
- Adding a new feature to the user profile.

These should be three separate commits.