---
name: ""
overview: ""
todos: []
isProject: false
---

# Plan: Head Soccer Multiplayer

## Overview

Add real-time multiplayer support to the Head Soccer game using Supabase Realtime or Firestore.

## Steps

1. **Backend**
  - Set up Supabase project or Firebase
  - Define game state schema: `{ player1, player2, ball, score }`
2. **Sync Service**
  - Create `GameSyncService` in `packages/cursor_edu_game`
  - Subscribe to realtime channel
  - Emit local player inputs, receive remote state
3. **Lobby**
  - Add lobby screen: create/join room
  - Matchmaking or room codes
4. **Game Integration**
  - KafaTopuGame listens to sync service
  - Interpolate remote player/ball positions
  - Authority: host or server-authoritative for ball

## Acceptance Criteria

- Two players can join same room
- Ball and player positions sync in real-time
- Score updates on both clients
- Graceful disconnect handling

