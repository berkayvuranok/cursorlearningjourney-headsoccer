import 'package:equatable/equatable.dart';

import '../data/profile_repository.dart';

enum ProfileStatus { initial, loading, success, error }

class ProfileState extends Equatable {
  const ProfileState({
    this.status = ProfileStatus.initial,
    this.deviceId,
    this.profile,
    this.myLeaderboardEntry,
    this.matches = const [],
    this.leaderboard = const [],
    this.errorMessage,
  });

  final ProfileStatus status;
  final String? deviceId;
  final ProfileRow? profile;
  final ProfileRow? myLeaderboardEntry;
  final List<MatchRow> matches;
  final List<ProfileRow> leaderboard;
  final String? errorMessage;

  ProfileState copyWith({
    ProfileStatus? status,
    String? deviceId,
    ProfileRow? profile,
    ProfileRow? myLeaderboardEntry,
    List<MatchRow>? matches,
    List<ProfileRow>? leaderboard,
    String? errorMessage,
    bool clearError = false,
  }) {
    return ProfileState(
      status: status ?? this.status,
      deviceId: deviceId ?? this.deviceId,
      profile: profile ?? this.profile,
      myLeaderboardEntry: myLeaderboardEntry ?? this.myLeaderboardEntry,
      matches: matches ?? this.matches,
      leaderboard: leaderboard ?? this.leaderboard,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [status, deviceId, profile, myLeaderboardEntry, matches, leaderboard, errorMessage];
}
