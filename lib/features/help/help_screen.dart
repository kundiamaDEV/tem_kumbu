import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajuda'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: const Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Como usar o Tem Kumbo',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Text(
              '1. Insira a zona onde deseja localizar ATM’s.\n\n'
              '2. Clique em PESQUISAR.\n\n'
              '3. Veja os ATM’s mais próximos.\n\n'
              '4. Toque num ATM para ver os detalhes.\n\n'
              '5. A partir dos detalhes, pode visualizar no mapa e traçar a rota.',
              style: TextStyle(
                fontSize: 16,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}