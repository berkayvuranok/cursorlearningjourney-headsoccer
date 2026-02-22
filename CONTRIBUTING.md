# Contributing

## Commit conventions

Use conventional commits. See [.cursor/rules/commit-conventions.mdc](.cursor/rules/commit-conventions.mdc).

### Enable commit template

```bash
git config commit.template .gitmessage
```

Then `git commit` (without `-m`) will open the template with types and sign-off reminder.

### Sign-off

Include: `Signed-off-by: @gurkanfikretgunak` when applicable.
