import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'config/routes.dart';
import 'core/services/theme_service.dart';
import 'config/themes.dart';

class MascotaSOSApp extends StatelessWidget {
  const MascotaSOSApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeService>(
      builder: (context, themeService, child) {
        return MaterialApp(
          title: 'MascotaSOS - Ica',
          debugShowCheckedModeBanner: false,
          theme: AppThemes.lightTheme,
          darkTheme: AppThemes.darkTheme,
          themeMode: themeService.themeMode,
          initialRoute: AppRoutes.splash,
          onGenerateRoute: AppRoutes.generateRoute,
          // No es necesario especificar home cuando se usa initialRoute
          // home: const SplashScreen(),
        );
      },
    );
  }
}
