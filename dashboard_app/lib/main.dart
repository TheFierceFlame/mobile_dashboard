import 'package:dashboard_app/api/firebase_api.dart';
import 'package:dashboard_app/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dashboard_app/config/theme/app_theme.dart';
import 'package:dashboard_app/presentation/screens/screens.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  await FirebaseAPI().initializeNotifications();
  runApp(const ProviderScope(child: MyApp()));
} 

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