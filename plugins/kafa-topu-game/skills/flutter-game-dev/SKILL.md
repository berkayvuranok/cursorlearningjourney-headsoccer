---
name: flutter-game-dev
description: Flutter Flame ile kafa topu benzeri multiplayer futbol oyunu geliştirme. Oyun döngüsü, fizik motoru, collision detection ve real-time senkronizasyon. Kullanım: Flutter/Flame oyun projeleri, multiplayer head soccer geliştirirken.
---

# Flutter Kafa Topu Oyunu Geliştirme

## Oyun Mimarisi

Kafa topu oyunu (head soccer) benzeri yapı:
- **Oyuncular**: İki karakter, her biri kafa ile topa vurur
- **Saha**: 2D yan görünüm, kale ve orta çizgi
- **Top**: Fizik tabanlı hareket, bounce ve collision

### Bileşenler

```
GameWorld
├── Player1 (Sol)
├── Player2 (Sağ)
├── Ball
├── GoalLeft
├── GoalRight
└── Ground
```

## Flutter Flame Yapısı

### Ana Oyun Sınıfı

```dart
// flame_game.dart
class KafaTopuGame extends FlameGame with HasCollisionDetection {
  @override
  Future<void> onLoad() async {
    await add(PlayerComponent(1));
    await add(PlayerComponent(2));
    await add(BallComponent());
  }
}
```

### Fizik ve Hareket

- `PositionComponent` + `Velocity` kullan
- Bounce: `velocity.y *= -0.8` (damping)
- Collision: `HitboxRectangle` + `CollisionCallback`
- Gravity: ~9.8 * scale factor

### Multiplayer Strateji

1. **Supabase Realtime**: Düşük gecikme WebSocket
2. **Firestore**: Basit senkronizasyon (tick rate düşük olabilir)
3. **WebSocket + Custom Server**: Tam kontrol (Node.js/Dart server)

Senkronizasyon verisi:
```dart
// GameState
{
  "player1": {"x": 100, "y": 300, "velocityY": 0},
  "player2": {"x": 700, "y": 300, "velocityY": 0},
  "ball": {"x": 400, "y": 250, "vx": 5, "vy": -2},
  "score": [0, 0]
}
```

## Checklist

- [ ] Flame `Game` veya `FlameGame` extend et
- [ ] `HasCollisionDetection` mixin ekle
- [ ] Player ve Ball için `Hitbox` tanımla
- [ ] `onCollision` callback ile vuruş/atak tespiti
- [ ] Skor mantığı: top kale çizgisini geçince
- [ ] Lobby/room sistemi multiplayer için
