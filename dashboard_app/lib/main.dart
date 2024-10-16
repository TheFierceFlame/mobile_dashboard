import 'package:flutter/material.dart';
import 'package:dashboard_app/config/theme/app_theme.dart';
import 'package:dashboard_app/presentation/screens/screens.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dashboard App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme().getTheme(),
      home: const SplashScreen()
    );
  }
}