# Cursor Edu – Agent Context

This project references the MasterFabric Core architecture. See [ARCHITECTURE.md](../docs/ARCHITECTURE.md).

## Project Structure

- **packages/cursor_edu_core**: Base classes, MasterView, BLoC/Cubit, DI, routing
- **packages/cursor_edu_game**: Flame game infrastructure, base game components
- **kafa_topu_game**: Head Soccer (Kafa Topu) multiplayer game
- **tools/ai_pr_bot**: AI-powered PR creation and review

## Conventions

- **Commits**: conventional commits – see `.cursor/rules/commit-conventions.mdc`, template: `.gitmessage`
- **File**: snake_case (`home_screen.dart`, `game_cubit.dart`)
- **Class**: PascalCase (`HomeScreen`, `GameCubit`)
- **State**: Equatable + `copyWith()` + `props`
- **View**: MasterView pattern – `initialContent()`, `viewContent()`
- **Cubit**: Extend `BaseViewModelCubit`, use `stateChanger()` (not emit)

## Important Paths

- Base classes: `packages/cursor_edu_core/lib/src/base/`
- Game logic: `packages/cursor_edu_game/lib/src/`
- Kafa Topu features: `kafa_topu_game/lib/src/features/`
- Rules: `.cursor/rules/`
- Skills: `.cursor/skills/`

## Skills

- `/base-pattern-documentation` – Base class documentation
- `/flutter-game-dev` – Flame / Head Soccer game development
- `/ai-pr-create` – PR creation
- `/ai-pr-review` – PR code review
