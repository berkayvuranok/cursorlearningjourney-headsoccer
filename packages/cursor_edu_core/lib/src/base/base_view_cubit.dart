import 'package:flutter_bloc/flutter_bloc.dart';

/// 🌟
/// BaseViewModelCubit is the base class for all Cubit-based view models.
/// Provides consistent state updates via stateChanger.
///
/// Features:
/// - 🔄 stateChanger() for emit
/// - 🛡️ Error handling
/// - 🧩 Extensible
abstract class BaseViewModelCubit<S> extends Cubit<S> {
  BaseViewModelCubit(super.initialState);

  /// Use for state updates. Prefer stateChanger over emit.
  void stateChanger(S newState) {
    emit(newState);
  }
}
