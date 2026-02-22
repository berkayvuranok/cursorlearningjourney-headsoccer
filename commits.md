# Commit Conventions

## Format

**MANDATORY:** Always use `type: description` – lowercase type, colon, space, then description.

- ✅ `update: home screen layout`
- ✅ `add: location picker`
- ❌ `Update home screen` (no colon, capitalized)
- ❌ `update home screen` (missing colon)

```
type: short description
```

## Types

| Type | Description |
|------|-------------|
| feat | A new feature is introduced with the changes |
| fix | A bug fix has occurred |
| chore | Changes that do not relate to a fix or feature and don't modify src or test files (e.g. updating dependencies) |
| refactor | Refactored code that neither fixes a bug nor adds a feature |
| docs | Updates to documentation (README, markdown, etc.) |
| style | Changes that do not affect the meaning of the code (formatting, white-space, semi-colons) |
| test | Including new or correcting previous tests |
| perf | Performance improvements |
| ci | Continuous integration related |
| build | Changes that affect the build system or external dependencies |
| revert | Reverts a previous commit |
| add | Adding a new file, function, method, variable |
| remove | Removing a file, function, method, variable |
| update | Updating a file, function, method, variable |
| rename | Renaming a file, function, method, variable |
| move | Moving a file, function, method, variable |
| copy | Copying a file, function, method, variable |
| security | Vulnerabilities |
| hotfix | A bug hot fix has occurred |

## Sign-off

```
Signed-off-by: @gurkanfikretgunak
```
