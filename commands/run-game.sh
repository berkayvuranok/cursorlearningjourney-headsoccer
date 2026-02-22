#!/bin/bash
# Run Head Soccer game
# Usage: ./commands/run-game.sh [device]

cd "$(dirname "$0")/../kafa_topu_game" || exit 1
flutter run "$@"
