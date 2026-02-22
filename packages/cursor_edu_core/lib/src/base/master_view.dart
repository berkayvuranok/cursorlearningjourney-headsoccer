import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// 🌟
/// MasterView provides scaffold for feature screens.
/// Implement initialContent and viewContent.
///
/// Features:
/// - 🔗 BLoC/Cubit lifecycle
/// - 🛡️ Consistent structure
/// - 🧩 viewContent for UI
abstract class MasterView<C extends Cubit<S>, S> extends StatefulWidget {
  const MasterView({
    super.key,
    required this.cubit,
    this.useSafeArea = true,
  });

  final C cubit;
  final bool useSafeArea;

  /// Called once on first load.
  void initialContent(C cubit, BuildContext context);

  /// Ana UI burada build edilir.
  Widget viewContent(BuildContext context, C cubit, S state);

  @override
  State<MasterView<C, S>> createState() => _MasterViewState<C, S>();
}

class _MasterViewState<C extends Cubit<S>, S> extends State<MasterView<C, S>> {
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
      (widget as MasterView<C, S>).initialContent(widget.cubit, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<C>.value(
      value: widget.cubit,
      child: BlocBuilder<C, S>(
        builder: (context, state) {
          return Scaffold(
            body: widget.useSafeArea
                ? SafeArea(
                    child: (widget as MasterView<C, S>).viewContent(
                      context,
                      widget.cubit,
                      state,
                    ),
                  )
                : (widget as MasterView<C, S>).viewContent(
                    context,
                    widget.cubit,
                    state,
                  ),
          );
        },
      ),
    );
  }
}
