---
name: ai-pr-review
description: Pull Request code review. Security, quality, best practices, potential bugs. Use when PR review requested, "review code" or diff/PR link provided.
---

# AI PR Bot - Code Review

## Criteria

1. **Security**: SQL injection, XSS, auth bypass, secret leak
2. **Logic**: Edge cases, null, error handling
3. **Performance**: Unnecessary loops, N+1 query
4. **Readability**: Naming, function size
5. **Tests**: Is changed code covered by tests?

## Output

- Critical (must fix)
- Suggestions
- Good points
