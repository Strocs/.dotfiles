# Global Commit Message Guidelines

## Core Philosophy: Granular & Atomic Commits

The primary goal is to create a clean, readable, and understandable git history. This is achieved by creating small, atomic commits. **You must create many small, focused commits over a few large, complex ones.**

## Commit Message Guidelines:

-   **Format:** All commit messages must follow the Conventional Commits specification.
    -   **Prefixes:** `feat`, `fix`, `docs`, `style`, `refactor`, `test`, `chore`.
-   **Subject Line:**
    -   50 characters max.
    -   Start with a capital letter.
    -   Do not end with a period.
    -   Must be a concise summary of the change.
-   **Body:**
    -   **You must not use a commit body for simple or self-explanatory changes.**
    -   A commit body is required **only** for the following situations:
        -   **Breaking Changes:** To explain the nature of the breaking change and the migration path.
        -   **Complex Refactorings:** To explain the reasoning behind the refactoring and the approach taken.
        -   **Bug Fixes with Non-Obvious Solutions:** To explain the cause of the bug and the rationale for the fix.
    -   If used, you must separate it from the subject with a blank line and wrap it at 72 characters.

## Workflow for Creating Commits:

The task of creating and pushing commits starts when I ask you to, and ends when the changes are successfully pushed to the remote repository.

1.  **Analyze Changes:** When I ask you to create commits, you must first perform a thorough analysis of all staged and unstaged changes (`git diff` and `git status`). This will give you a complete picture of the changes, including untracked files.
2.  **Group Logically:** You must group the file changes into small, logical, and atomic units. **Unrelated changes must not be in the same commit.**
3.  **Propose Commit Plan:** Before taking any action, you must propose a plan to me. For each commit you intend to create, you must list:
    -   The generated commit message (subject and body, if applicable).
    -   The list of files that will be included in that specific commit.
4.  **Await Approval:** You must not proceed with staging files or creating commits until I approve the plan. If I am not happy with the proposed plan, you must ask for my feedback and propose a new plan, instead of taking any action that might be destructive.
5.  **Execute and Push:** Once the plan is approved, you must execute the commits as planned and push the changes to the remote repository.

### Triggering Commit Creation

I will use this key phrase to trigger the commit creation process:

- Generate commits
- Create commits
- Make commits

### Confidence Mode

If I explicitly tell you that I trust you, or to use "Confidence Mode", you should skip the approval steps (3, 4 and 5). In this mode, you will:

1.  Analyze the changes.
2.  Generate the commits based on the logical grouping.
3.  Directly execute the commits.
4.  Finally, push the changes to the remote repository without asking for my approval.

#### Trigger Examples with confidence mode
- Generate commits, use confidence mode.
- Create commit, I trust you
- make commits, confidence mode

---

## Safety and Destructive Operations

-   **Forbidden Commands:** The use of `git reset --hard` is strictly forbidden. Any other command that can lead to data loss must be treated with extreme caution.
-   **Safe Alternatives:** When a situation requires to undo changes, you must always prefer safe alternatives like `git reset --soft` (which keeps the changes in the working directory) or creating a new branch for recovery.
-   **User Confirmation:** For any destructive operation (like `git push --force`), you must explain the risks in detail and get explicit confirmation from me before proceeding.
-   **"Start Over" Requests:** If I ask you to "start over" or "try again", you must not interpret it as a request to destroy the work done so far. Instead, you must ask for clarification and propose a new plan to move forward without losing any work.

## Communication Style

-   **Clarity and Transparency:** You must always be clear and transparent in your communication, especially when dealing with complex or risky operations.
-   **Empathy and Professionalism:** You must always be empathetic and professional, especially when I am frustrated.
-   **Proactive Communication:** You must be proactive in your communication, for example, by informing me about potential risks or ambiguities.

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

#### Example of Breaking Down a Large Change:

A request to "refactor the user authentication system" could be broken down into the following commits:

1.  `feat(auth): Add JWT generation and validation`
2.  `refactor(auth): Replace cookie-based sessions with JWT`
3.  `test(auth): Add unit tests for JWT authentication`
4.  `docs(auth): Update documentation for the new authentication system`
