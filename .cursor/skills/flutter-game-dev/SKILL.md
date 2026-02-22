---
name: flutter-game-dev
description: Flutter Flame head soccer style multiplayer football game development. Game loop, physics, collision detection, real-time sync. Use when building Flutter/Flame games or multiplayer head soccer.
---

# Flutter Head Soccer Game Development

## Game Architecture

- **Players**: Two characters, kick the ball with head
- **Field**: 2D side view, goals and center line
- **Ball**: Physics-based movement, bounce, collision

```
GameWorld
├── Player1 (Left)
├── Player2 (Right)
├── Ball
├── GoalLeft / GoalRight
└── Ground
```

## Flame Structure

- `FlameGame` + `HasCollisionDetection`, `KeyboardEvents`
- `PositionComponent` + `Velocity`, gravity, bounce damping
- `HitboxRectangle` / `CircleHitbox`, `CollisionCallbacks`
- `HasGameReference<T>` (game access)

## Multiplayer

- Supabase Realtime, Firestore, or WebSocket
- Sync: player1/2 pos, ball pos/vel, score
