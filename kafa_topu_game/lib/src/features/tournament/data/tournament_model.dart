/// Tournament result for rank calculation.
class TournamentMatchResult {
  const TournamentMatchResult({
    required this.matchId,
    required this.player1Id,
    required this.player2Id,
    required this.score1,
    required this.score2,
    required this.winnerId,
  });

  final String matchId;
  final String player1Id;
  final String player2Id;
  final int score1;
  final int score2;
  final String? winnerId; // null = draw
}

class Tournament {
  const Tournament({
    required this.id,
    required this.name,
    required this.results,
  });

  final String id;
  final String name;
  final List<TournamentMatchResult> results;
}
