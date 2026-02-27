import 'package:cursor_edu_core/cursor_edu_core.dart';

import '../../../core/device_id.dart';
import '../data/profile_repository.dart';
import '../../../shared/player_profile.dart';
import 'profile_state.dart';

class ProfileCubit extends BaseViewModelCubit<ProfileState> {
  ProfileCubit() : super(const ProfileState());

  final _repo = ProfileRepository.instance;

  Future<void> load() async {
    stateChanger(state.copyWith(status: ProfileStatus.loading, clearError: true));
    try {
      final deviceId = await getOrCreateDeviceId();
      final profile = await _repo.getProfileByDeviceId(deviceId);
      final matches = await _repo.getMatchesForDevice(deviceId);
      final leaderboard = await _repo.getLeaderboard();
      ProfileRow? myEntry;
      try {
        myEntry = leaderboard.firstWhere((e) => e.deviceId == deviceId);
      } catch (_) {
        myEntry = null;
      }
      stateChanger(state.copyWith(
        status: ProfileStatus.success,
        deviceId: deviceId,
        profile: profile ?? ProfileRow(id: '', deviceId: deviceId, displayName: 'Player', skin: 'classicGreen'),
        myLeaderboardEntry: myEntry,
        matches: matches,
        leaderboard: leaderboard,
      ));
    } catch (e) {
      stateChanger(state.copyWith(
        status: ProfileStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> saveProfile(String displayName, PlayerSkin skin) async {
    final deviceId = state.deviceId;
    if (deviceId == null) return;
    final row = await _repo.upsertProfile(deviceId, displayName, ProfileRow.skinToString(skin));
    if (row != null) {
      stateChanger(state.copyWith(profile: row));
    }
  }
}
