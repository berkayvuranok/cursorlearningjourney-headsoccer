import 'package:flutter/material.dart';

/// Simple widget for empty state.
class EmptyView extends StatelessWidget {
  const EmptyView({
    super.key,
    this.message = 'No data yet',
  });

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(message),
    );
  }
}
