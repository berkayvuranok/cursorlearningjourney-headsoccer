# Cursor Edu Plugin

Cursor IDE plugin for Cursor Edu. Provides Rules, Skills, and Agents for Flutter projects following MasterFabric Core architecture, Flame game development (Head Soccer), and AI PR Bot.

## Installation

**Settings → Plugins → Add from URL**

```
https://github.com/[org]/cursor_edu
```

## Contents

| Component | Description |
|-----------|-------------|
| **Rules** | cursor-edu-conventions, create-view, create-helper, flutter-flame-patterns, error-handling, language-english-only |
| **Skills** | base-pattern-documentation, flutter-game-dev, ai-pr-create, ai-pr-review |
| **MCP** | Dart MCP server (format, analyze, test, pub.dev) |

## Project Structure

- `packages/cursor_edu_core` – Base classes, MasterView, BLoC, DI
- `packages/cursor_edu_game` – Flame game infrastructure
- `kafa_topu_game` – Head Soccer multiplayer game
- `tools/ai_pr_bot` – AI PR creation and review

## References

- [MasterFabric Core](https://github.com/gurkanfikretgunak/masterfabric_core)
- [ARCHITECTURE.md](docs/ARCHITECTURE.md)
