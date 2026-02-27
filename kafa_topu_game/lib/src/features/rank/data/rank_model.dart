/// Rank tier based on tournament results.
enum RankTier {
  bronze,
  silver,
  gold,
  platinum,
  diamond,
  champion,
}

extension RankTierX on RankTier {
  String get label {
    switch (this) {
      case RankTier.bronze:
        return 'Bronze';
      case RankTier.silver:
        return 'Silver';
      case RankTier.gold:
        return 'Gold';
      case RankTier.platinum:
        return 'Platinum';
      case RankTier.diamond:
        return 'Diamond';
      case RankTier.champion:
        return 'Champion';
    }
  }
}

class RankEntry {
  const RankEntry({
    required this.playerId,
    required this.displayName,
    required this.tier,
    required this.points,
    required this.wins,
    required this.losses,
  });

  final String playerId;
  final String displayName;
  final RankTier tier;
  final int points;
  final int wins;
  final int losses;

  double get winRate => (wins + losses) > 0 ? wins / (wins + losses) : 0.0;
}
