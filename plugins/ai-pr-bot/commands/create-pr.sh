#!/bin/bash
# AI PR Bot - PR Oluşturma Komutu
# Kullanım: ./create-pr.sh [base_branch]

set -e
BASE_BRANCH="${1:-main}"
CURRENT_BRANCH=$(git branch --show-current)

if [ "$CURRENT_BRANCH" = "$BASE_BRANCH" ]; then
  echo "Yeni bir feature branch oluşturmalısınız."
  read -p "Branch adı (örn: feature/add-login): " BRANCH_NAME
  git checkout -b "$BRANCH_NAME"
fi

echo "=== Staged değişiklikler ==="
git status
echo ""
echo "Commit ve push için Cursor AI'dan 'PR oluştur' veya 'ai pr create' yazın."
echo "AI diff'i analiz edip uygun commit mesajı ve PR açıklaması üretecektir."
