import 'package:flutter/material.dart';
import 'core/app_theme.dart';
import 'core/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const NihonGoApp());
}

class NihonGoApp extends StatelessWidget {
  const NihonGoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'NihonGo! - Luyện tiếng Nhật',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      routerConfig: appRouter,
    );
  }
}
