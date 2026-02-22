---
name: ai-pr-create
description: AI destekli Pull Request oluşturma. Git diff analizi, PR başlığı/açıklaması üretme, branch stratejisi. Kullanım: PR oluşturacağın zaman, "PR yap", "pull request oluştur" veya kod değişikliğini PR'a çevirmek istediğinde.
---

# AI PR Bot - PR Oluşturma

## Akış

1. **Değişiklikleri Analiz Et**: `git status`, `git diff --staged` veya `git diff main`
2. **Commit Mesajı Üret**: Conventional commits formatında (feat/fix/docs/style/refactor/test/chore)
3. **PR Başlığı**: Kısa, açıklayıcı, max 72 karakter
4. **PR Açıklaması**: Değişiklik özeti, test notları, breaking changes varsa belirt

## PR Şablonu

```markdown
## Değişiklikler
- [Ana değişiklik 1]
- [Ana değişiklik 2]

## Test
- [ ] Manuel test yapıldı
- [ ] Unit testler geçiyor

## Ek Notlar
[Varsa]
```

## Conventional Commits

- `feat`: Yeni özellik
- `fix`: Bug fix
- `docs`: Dokümantasyon
- `style`: Format, boşluk (kod değişmez)
- `refactor`: Yeniden yapılandırma
- `test`: Test ekleme/düzeltme
- `chore`: Build, CI, paket güncelleme

Örnek: `feat(auth): JWT login ekle`

## Bot Komutları

- PR oluştur: değişiklikleri analiz et → branch oluştur → commit → push → PR aç
- Sadece PR açıklaması üret: mevcut branch için markdown hazırla
