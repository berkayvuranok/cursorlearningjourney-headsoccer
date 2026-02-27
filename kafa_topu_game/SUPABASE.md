# Supabase – Head Soccer Online

Online maç senkronizasyonu (ör. “rakip ayarlarda” bekleme) Supabase Realtime Broadcast kullanır. Giriş/Kayıt (auth) ve profil Supabase’den çekilir.

## Kurulum

1. [Supabase](https://supabase.com) projesi oluştur.
2. **Settings → API** içinden **Project URL** ve **anon public** key’i kopyala.
3. **.env dosyası:** Proje kökündeki `.env` dosyasına bu değerleri yazın:

```
SUPABASE_URL=https://YOUR_PROJECT_REF.supabase.co
SUPABASE_ANON_KEY=your-anon-key-here
```

`.env.example` dosyasını `.env` olarak kopyalayıp kendi değerlerinizi girebilirsiniz. `.env` dosyası asset olarak kullanıldığı için projede placeholder’lı bir `.env` bulunur; gerçek key’i sadece kendi ortamınızda kullanın.

Alternatif (dart-define ile):

```bash
flutter run --dart-define=SUPABASE_URL=https://YOUR_PROJECT.supabase.co --dart-define=SUPABASE_ANON_KEY=your-anon-key
```

## Kullanım

- **Online maç** açıldığında uygulama `head_soccer:room:default` Realtime kanalına bağlanır.
- Bir oyuncu ayarlara girince `player_entered_settings` broadcast gönderilir; diğer cihazda “Rakip ayarlarda – 10 sn bekleme” gösterilir.
- Ayarlardan çıkınca `player_left_settings` gönderilir ve bekleme kalkar.

Tablolar: `supabase/migrations/20250222000000_create_tables.sql` (profiles, matches, leaderboard view). SQL Editor’da çalıştırın.

İleride oda kodu (örn. “ABC123”) ile farklı kanallar (`head_soccer:room:ABC123`) kullanılabilir.
