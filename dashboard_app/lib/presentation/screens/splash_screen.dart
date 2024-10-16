import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:dashboard_app/presentation/screens/screens.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 3000), () {
      if (!mounted) return;
      Navigator.pushReplacement(
        context, 
        MaterialPageRoute(builder: (context) {
          return const AnalyticsScreen();
        })
      );
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange[900],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FadeInDown(
              duration: const Duration(milliseconds: 1500),
              child: Image.asset('images/Logo.png')
            ),
            const SizedBox(height: 50),
            FadeIn(
              delay: const Duration(milliseconds: 1500),
              duration: const Duration(milliseconds: 1500),
              child: const Text(
                'Dashboard App',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20
                ),
              )
            )
          ],
        )
      )
    );
  }
}