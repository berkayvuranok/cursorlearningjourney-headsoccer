#!/bin/bash
# AI PR Bot - Create Pull Request
# Usage: ./commands/create-pr.sh [base_branch]

set -e
BASE_BRANCH="${1:-main}"
CURRENT=$(git branch --show-current)

if [ "$CURRENT" = "$BASE_BRANCH" ]; then
  echo "Create a feature branch first. Example: git checkout -b feature/your-feature"
  exit 1
fi

echo "=== Current branch: $CURRENT ==="
echo "=== Staged changes ==="
git status
echo ""
echo "Run 'git add' then commit. Use Cursor AI '/ai-pr-create' to generate PR description."
