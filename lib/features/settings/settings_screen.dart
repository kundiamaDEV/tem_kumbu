import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificacoes = true;
  bool _localizacaoAutomatica = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuração'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Preferências',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          SwitchListTile(
            value: _notificacoes,
            title: const Text('Receber notificações'),
            secondary: const Icon(Icons.notifications_none),
            onChanged: (value) {
              setState(() {
                _notificacoes = value;
              });
            },
          ),
          SwitchListTile(
            value: _localizacaoAutomatica,
            title: const Text('Usar localização automática'),
            secondary: const Icon(Icons.my_location),
            onChanged: (value) {
              setState(() {
                _localizacaoAutomatica = value;
              });
            },
          ),
        ],
      ),
    );
  }
}