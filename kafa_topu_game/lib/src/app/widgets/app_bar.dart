import 'package:flutter/material.dart';

/// Unified app bar for Head Soccer: gradient, title, optional actions.
class HeadSoccerAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HeadSoccerAppBar({
    super.key,
    this.title = 'HEAD SOCCER',
    this.leading,
    this.actions,
    this.showBack = false,
    this.onBack,
  });

  final String title;
  final Widget? leading;
  final List<Widget>? actions;
  final bool showBack;
  final VoidCallback? onBack;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.green.shade900,
            Colors.green.shade800,
            Colors.green.shade700,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            offset: const Offset(0, 2),
            blurRadius: 4,
          ),
        ],
      ),
      child: AppBar(
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.5,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: leading ??
            (showBack
                ? IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                    onPressed: onBack ?? () => Navigator.of(context).pop(),
                  )
                : null),
        actions: actions,
      ),
    );
  }
}
