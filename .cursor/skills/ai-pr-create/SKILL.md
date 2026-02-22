---
name: ai-pr-create
description: AI-powered Pull Request creation. Git diff analysis, PR title/description generation, branch strategy. Use when creating PRs, "create PR", "open pull request" or converting code changes to PR.
---

# AI PR Bot - PR Creation

## Flow

1. Analyze changes: `git status`, `git diff --staged` or `git diff main`
2. Conventional commits: feat/fix/docs/style/refactor/test/chore
3. PR title: short, max 72 characters
4. PR description: summary, test notes, breaking changes

## Conventional Commits

- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation
- `style`: Formatting
- `refactor`: Restructuring
- `test`: Tests
- `chore`: Build, CI, packages

Example: `feat(auth): add JWT login`
