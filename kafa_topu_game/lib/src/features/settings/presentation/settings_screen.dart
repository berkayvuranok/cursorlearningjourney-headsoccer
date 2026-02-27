import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kafa_topu_game/src/shared/shared.dart';
import 'package:kafa_topu_game/src/app/widgets/app_bar.dart';
import 'package:kafa_topu_game/src/features/online/data/online_session_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key, this.fromOnlineGame = false});

  final bool fromOnlineGame;

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late final PlayerProfileManager _manager;
  late final TextEditingController _name1Controller;
  late final TextEditingController _name2Controller;

  @override
  void initState() {
    super.initState();
    _manager = PlayerProfileManager.instance;
    _name1Controller = TextEditingController(text: _manager.player1.name);
    _name2Controller = TextEditingController(text: _manager.player2.name);
  }

  void _onBack() {
    if (widget.fromOnlineGame) {
      OnlineSessionService.instance.notifyImBackFromSettings();
    }
    context.pop();
  }

  @override
  void dispose() {
    if (widget.fromOnlineGame) {
      OnlineSessionService.instance.notifyImBackFromSettings();
    }
    _name1Controller.dispose();
    _name2Controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: HeadSoccerAppBar(
        title: 'AYARLAR',
        showBack: true,
        onBack: _onBack,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.green.shade900,
              Colors.green.shade700,
            ],
          ),
        ),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                'Players',
                style: theme.textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _buildPlayerCard('Player 1', _manager.player1, _name1Controller),
              const SizedBox(height: 16),
              _buildPlayerCard('Player 2', _manager.player2, _name2Controller),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlayerCard(
    String title,
    PlayerProfile profile,
    TextEditingController nameController,
  ) {
    return Card(
      color: Colors.black.withValues(alpha: 0.2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: nameController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Name',
                labelStyle: TextStyle(color: Colors.white70),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white54),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
              onChanged: (value) => profile.name = value,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<PlayerSkin>(
              key: ValueKey<PlayerSkin>(profile.skin),
              dropdownColor: Colors.black87,
              initialValue: profile.skin,
              decoration: const InputDecoration(
                labelText: 'Costume',
                labelStyle: TextStyle(color: Colors.white70),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white54),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
              iconEnabledColor: Colors.white,
              items: PlayerSkin.values
                  .map(
                    (skin) => DropdownMenuItem<PlayerSkin>(
                      value: skin,
                      child: Text(
                        skin.label,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value == null) return;
                setState(() => profile.skin = value);
              },
            ),
          ],
        ),
      ),
    );
  }
}

