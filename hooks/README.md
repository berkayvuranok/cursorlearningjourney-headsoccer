# Hooks

Copy these to `.git/hooks/` to enable:

**Commit template**: `git config commit.template .gitmessage` – uses `.gitmessage` for conventional commits.

```bash
cp hooks/pre-commit .git/hooks/pre-commit
chmod +x .git/hooks/pre-commit
```
