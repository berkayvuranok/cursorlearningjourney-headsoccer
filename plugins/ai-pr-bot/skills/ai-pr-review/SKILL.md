---
name: ai-pr-review
description: Pull Request kod incelemesi. Güvenlik, kalite, best practice, potansiyel bug kontrolü. Kullanım: PR review isteğinde, "kod incele" veya diff/PR linki verildiğinde.
---

# AI PR Bot - Kod İncelemesi

## İnceleme Kriterleri

1. **Güvenlik**: SQL injection, XSS, auth bypass, secret leak
2. **Mantık**: Edge case, null/undefined, hata yakalama
3. **Performans**: Gereksiz loop, N+1 query, büyük asset
4. **Okunabilirlik**: İsimlendirme, fonksiyon boyutu, yorum
5. **Test**: Değişen kod test edilmiş mi?

## Çıktı Formatı

```markdown
## PR Review

### Genel
[Kısa özet]

### Kritik (Mutlaka düzelt)
- [ ] Madde 1
- [ ] Madde 2

### Öneriler
- Madde 1
- Madde 2

### İyi Noktalar
- ...
```

## Otomatik Çalışma

- PR webhook'u tetiklenince review başlat
- GitHub API veya `git diff` ile değişiklikleri al
- AI ile analiz → yorum olarak PR'a ekle
