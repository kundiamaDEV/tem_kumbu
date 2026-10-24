import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contacto'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: const Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Entre em contacto connosco',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.email_outlined),
              title: Text('Email'),
              subtitle: Text('suporte@temkumbo.ao'),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.phone_outlined),
              title: Text('Telefone'),
              subtitle: Text('+244 945 560 400 / 952 142 799'),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.location_on_outlined),
              title: Text('Endereço'),
              subtitle: Text('Luanda, Angola'),
            ),
          ],
        ),
      ),
    );
  }
}