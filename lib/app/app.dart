import 'package:flutter/material.dart';
import 'router.dart';
import 'theme/app_theme.dart';

class TemKumboApp extends StatelessWidget {
  const TemKumboApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tem Kumbo',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: AppRoutes.splash,
      onGenerateRoute: AppRoutes.onGenerateRoute,
    );
  }
}