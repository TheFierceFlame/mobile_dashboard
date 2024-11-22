import 'package:dashboard_app/api/firebase_api.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:dashboard_app/config/theme/app_theme.dart';
import 'package:dashboard_app/presentation/screens/screens.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseAPI().initializeNotifications();
  runApp(const ProviderScope(child: MyApp()));
}

final GoRouter router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const SplashScreen();
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'Analytics',
          builder: (BuildContext context, GoRouterState state) {
            return const AnalyticsScreen();
          },
        ),
        GoRoute(
          path: 'ProductsAnalytics',
          builder: (BuildContext context, GoRouterState state) {
            return const ProductsAnalyticsScreen();
          },
        ),
        GoRoute(
          path: 'DebtorsAnalytics',
          builder: (BuildContext context, GoRouterState state) {
            return const DebtorsAnalyticsScreen();
          },
        ),
      ],
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Dashboard App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme().getTheme(),
      routerConfig: router,
    );
  }
}