# Cursor Edu - Architecture Design

Project structure designed to reference [MasterFabric Core](https://github.com/gurkanfikretgunak/masterfabric_core) architecture.

---

## 1. Overview

```
cursor_edu/
├── packages/
│   ├── cursor_edu_core/         # Base architecture, base classes, helpers
│   └── cursor_edu_game/         # Game infrastructure (Flame wrapper)
├── kafa_topu_game/              # Head Soccer game app
├── tools/
│   └── ai_pr_bot/               # AI PR Bot
├── .cursor-plugin/              # Cursor plugin (MasterFabric style)
│   └── plugin.json
├── .cursor/                     # Rules, skills, agents, mcp
├── commands/
├── hooks/
└── docs/
```

---

## 2. Layer Architecture

### 2.1 `cursor_edu_core` Package (MasterFabric Core style)

Base architecture layer – all apps depend on this package.

```
cursor_edu_core/
├── lib/
│   ├── cursor_edu_core.dart           # Main export
│   └── src/
│       ├── base/                      # Base classes
│       │   ├── base_view_cubit.dart
│       │   ├── base_view_bloc.dart
│       │   └── master_view.dart       # MasterView pattern
│       ├── di/                        # Dependency Injection
│       │   └── injection.dart         # GetIt/Injectable
│       ├── routing/                   # GoRouter integration
│       │   └── app_routes.dart
│       ├── helper/                    # Helper classes
│       │   ├── storage_helper.dart
│       │   ├── game_state_helper.dart
│       │   └── network_helper.dart
│       └── views/                     # Shared pre-built views
│           ├── loading_view.dart
│           ├── error_view.dart
│           └── empty_view.dart
└── pubspec.yaml
```

**Dependencies:**
- `flutter_bloc` / `bloc`
- `go_router`
- `get_it` / `injectable`
- `hydrated_bloc` (optional, state persistence)

### 2.2 `cursor_edu_game` Package

Game-specific infrastructure – Flame wrapper, shared game components.

```
cursor_edu_game/
├── lib/
│   ├── cursor_edu_game.dart
│   └── src/
│       ├── game/
│       │   ├── base_game.dart         # FlameGame + collision + input
│       │   └── game_screen.dart       # Material wrapper
│       ├── components/                # Shared components
│       │   ├── base_player.dart
│       │   ├── base_ball.dart
│       │   └── base_goal.dart
│       ├── physics/                   # Game physics
│       │   └── game_physics.dart
│       └── networking/                # Multiplayer (future)
│           └── game_sync_service.dart
└── pubspec.yaml
```

**Dependencies:**
- `flame`
- `cursor_edu_core`

### 2.3 `kafa_topu_game` Application

```
kafa_topu_game/
├── lib/
│   ├── main.dart
│   └── src/
│       ├── app/
│       │   ├── app.dart               # MaterialApp / MasterApp style
│       │   └── app_routes.dart        # App routes
│       ├── features/
│       │   ├── home/
│       │   │   ├── presentation/
│       │   │   │   ├── home_screen.dart
│       │   │   │   ├── home_cubit.dart
│       │   │   │   └── home_state.dart
│       │   │   └── home.dart
│       │   └── game/
│       │       ├── presentation/
│       │       │   ├── game_screen.dart
│       │       │   ├── game_cubit.dart
│       │       │   └── game_state.dart
│       │       ├── domain/
│       │       │   └── entities/
│       │       │       ├── player.dart
│       │       │       ├── ball.dart
│       │       │       └── score.dart
│       │       ├── data/
│       │       │   └── kafa_topu_game_impl.dart   # KafaTopuGame extends BaseGame
│       │       └── game.dart
│       ├── shared/
│       │   └── widgets/
│       └── assets/
├── assets/
│   ├── config/
│   │   └── app_config.json
│   ├── images/
│   └── audio/
└── pubspec.yaml
```

---

## 3. State Management (MasterFabric Pattern)

### Base View Pattern

```dart
// cursor_edu_core/base/base_view_cubit.dart
abstract class BaseViewCubit<T> extends Cubit<T> {
  BaseViewCubit(super.initialState);
  void onError(Object error, StackTrace stackTrace);
}

// cursor_edu_core/base/master_view.dart
abstract class MasterView<C extends Cubit<S>, S> extends StatelessWidget {
  void initialContent(C cubit, BuildContext context);
  Widget viewContent(BuildContext context, C cubit, S state);
}
```

### Head Soccer Example

```dart
// game_cubit.dart
class GameCubit extends Cubit<GameState> {
  final KafaTopuGame game;
  GameCubit(this.game) : super(GameState.initial());

  void onGoalScored(bool isLeftGoal) {
    emit(state.copyWith(
      score1: isLeftGoal ? state.score1 : state.score1 + 1,
      score2: isLeftGoal ? state.score2 + 1 : state.score2,
    ));
  }
}

// game_screen.dart – MasterView style
class GameScreen extends MasterView<GameCubit, GameState> {
  @override
  Widget viewContent(BuildContext context, GameCubit cubit, GameState state) {
    return Stack(
      children: [
        GameWidget<KafaTopuGame>(game: cubit.game),
        ScoreOverlay(score1: state.score1, score2: state.score2),
      ],
    );
  }
}
```

---

## 4. Dependency Injection (Injectable / GetIt)

```dart
// cursor_edu_core/di/injection.dart
final getIt = GetIt.instance;

@InjectableInit()
void configureDependencies() => getIt.init();

// For Head Soccer
@injectable
class GameCubit extends Cubit<GameState> {
  @factoryParam
  GameCubit(KafaTopuGame game) : super(GameState.initial());
}
```

---

## 5. Routing (GoRouter)

```dart
// cursor_edu_core/routing/app_routes.dart
class AppRoutes {
  static const String home = '/';
  static const String game = '/game';
}

// kafa_topu_game app_routes.dart
final router = GoRouter(
  initialLocation: AppRoutes.home,
  routes: [
    GoRoute(path: AppRoutes.home, builder: (_, __) => HomeScreen()),
    GoRoute(path: AppRoutes.game, builder: (_, __) => GameScreen()),
  ],
);
```

---

## 6. Config & Run Before (MasterFabric style)

```dart
// cursor_edu_core/app/app_runner.dart
class CursorEduApp {
  static Future<void> runBefore({
    required String assetConfigPath,
    bool hydrated = false,
    Set<RunBeforeFeature>? runBeforeFeatures,
  }) async {
    WidgetsFlutterBinding.ensureInitialized();
    // Load config (app_config.json)
    // Storage / Hydrated init
    // Permissions, network, etc.
  }
}

// main.dart
void main() async {
  await CursorEduApp.runBefore(
    assetConfigPath: 'assets/config/app_config.json',
    hydrated: true,
  );
  runApp(MyApp());
}
```

---

## 7. AI PR Bot Architecture

```
tools/ai_pr_bot/
├── lib/
│   ├── main.dart                 # CLI entry
│   └── src/
│       ├── commands/
│       │   ├── create_pr.dart
│       │   └── review_pr.dart
│       ├── services/
│       │   ├── git_service.dart
│       │   └── github_api_service.dart
│       └── models/
│           └── pr_model.dart
├── bin/
│   └── ai_pr_bot.dart
└── pubspec.yaml
```

Or with Node.js/TypeScript:

```
tools/ai_pr_bot/
├── src/
│   ├── commands/
│   ├── services/
│   └── models/
├── package.json
└── tsconfig.json
```

---

## 8. Cursor Plugin Integration

| Plugin         | Source                       | Description                                          |
|----------------|------------------------------|------------------------------------------------------|
| kafa-topu-game | `packages/cursor_edu_game`   | Flame game dev skills, rules, game patterns          |
| ai-pr-bot      | `tools/ai_pr_bot`            | PR creation, review skills, git automation           |

Plugins reference project code; distributed via marketplace.

---

## 9. Migration Plan

| Step | Description |
|------|-------------|
| 1    | Create `cursor_edu_core` package, move base classes |
| 2    | Create `cursor_edu_game` package, extract Flame components |
| 3    | Refactor `kafa_topu_game` to feature-based structure |
| 4    | DI and GoRouter integration |
| 5    | Configure AI PR Bot as tool |

---

## 10. Dependency Graph

```
kafa_topu_game (app)
    ├── cursor_edu_game
    │       └── cursor_edu_core
    └── cursor_edu_core

ai_pr_bot (tool)
    └── (standalone or cursor_edu_core CLI utils)
```

---

## References

- [MasterFabric Core](https://github.com/gurkanfikretgunak/masterfabric_core)
- [MasterFabric Plugin Docs](https://github.com/gurkanfikretgunak/masterfabric_core/blob/main/PLUGIN_README.md)
