# Cursor Edu

Flutter architecture project following **MasterFabric Core**, featuring a local multiplayer **Head Soccer (Kafa Topu)** game, AI PR tooling, and Cursor IDE plugin support.

---

## Overview

Cursor Edu is a monorepo containing:

- **Base architecture packages** – MasterView pattern, BLoC/Cubit, DI, routing
- **Head Soccer (Kafa Topu)** – 2-player local multiplayer Flutter game built with Flame
- **AI PR Bot** – PR creation and review workflows
- **Cursor Plugin** – Rules, skills, and agents for Flutter/Bloc/Flame development

---

## Features

| Component | Description |
|-----------|-------------|
| **cursor_edu_core** | BaseViewModelCubit, MasterView, GetIt DI, GoRouter, LoadingView, ErrorView |
| **cursor_edu_game** | BaseGame (Flame), GameScreenWrapper, shared game components |
| **kafa_topu_game** | Head Soccer – tap-to-play home, keyboard controls, goal detection |
| **AI PR Bot** | `/ai-pr-create`, `/ai-pr-review` skills for PR automation |
| **Cursor Plugin** | Rules, skills, agents, MCP for Cursor IDE |

---

## Architecture

The project follows [MasterFabric Core](https://github.com/gurkanfikretgunak/masterfabric_core) style architecture.

```
cursor_edu/
├── packages/
│   ├── cursor_edu_core/      # Base classes, MasterView, BLoC, DI, routing
│   └── cursor_edu_game/      # Flame game infrastructure, BaseGame
├── kafa_topu_game/           # Head Soccer app
├── tools/
│   └── ai_pr_bot/            # AI PR creation and review
├── .cursor-plugin/           # Cursor plugin manifest
├── .cursor/                  # Rules, skills, agents, MCP
├── commands/                 # Shell scripts (run-game, create-pr)
├── hooks/                    # Git hooks (pre-commit)
└── docs/                     # Architecture, plans
```

**Dependency chain:**
```
kafa_topu_game → cursor_edu_game → cursor_edu_core
```

See [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) for detailed design.

---

## Getting Started

### Prerequisites

- [Flutter](https://flutter.dev) 3.10+
- [Dart](https://dart.dev) 3.10+

### Installation

```bash
git clone https://github.com/cursor-edu/cursor_edu.git
cd cursor_edu
cd kafa_topu_game && flutter pub get && cd ..
```

### Run Head Soccer

- **[▶ Click to Run](command:workbench.action.tasks.build)** – runs Head Soccer (in Cursor/VS Code)
- Shortcut: `Cmd+Shift+B` (Mac) / `Ctrl+Shift+B` (Win/Linux)
- Script: `./commands/run-game.sh`

**Controls:**
- **Player 1**: W (up), A (left), D (right)
- **Player 2**: ↑ (up), ← (left), → (right)
- **Home screen**: Tap anywhere to start

---

## Commands

| Command | Description |
|---------|-------------|
| `./commands/run-game.sh` | Run Head Soccer |
| `./commands/run-game.sh -d chrome` | Run on web (Chrome) |
| `./commands/create-pr.sh` | Helper for AI PR creation |

See [commands/README.md](commands/README.md).

---

## Git Hooks

Copy hooks to enable pre-commit checks:

```bash
cp hooks/pre-commit .git/hooks/pre-commit
chmod +x .git/hooks/pre-commit
```

**Commit template** (conventional commits):

```bash
git config commit.template .gitmessage
```

See [hooks/README.md](hooks/README.md).

---

## Commit Conventions

Use [conventional commits](commits.md): `type(scope): description`

| Type | Description |
|------|-------------|
| feat | New feature |
| fix | Bug fix |
| chore | Config, deps (no src change) |
| docs | Documentation |
| refactor | Code change, no bug/feature |
| test | Tests |
| … | See [commits.md](commits.md) for full list |

**Sign-off:** `Signed-off-by: @gurkanfikretgunak`

---

## Cursor Plugin

The Cursor Edu plugin provides:

- **Rules**: cursor-edu-conventions, create-view, create-helper, flutter-flame-patterns, error-handling, language-english-only, commit-conventions
- **Skills**: base-pattern-documentation, flutter-game-dev, ai-pr-create, ai-pr-review
- **Agents**: flutter-architecture, flutter-game

**Installation:** Settings → Plugins → Add from URL → `https://github.com/cursor-edu/cursor_edu`

See [PLUGIN_README.md](PLUGIN_README.md).

---

## Contributing

1. Follow [commits.md](commits.md) for commit messages.
2. Enable commit template: `git config commit.template .gitmessage`
3. Copy pre-commit hook: `cp hooks/pre-commit .git/hooks/pre-commit`

See [CONTRIBUTING.md](CONTRIBUTING.md).

---

## References

- [MasterFabric Core](https://github.com/gurkanfikretgunak/masterfabric_core)
- [Flame Engine](https://docs.flame-engine.org)
- [Flutter BLoC](https://bloclibrary.dev)
