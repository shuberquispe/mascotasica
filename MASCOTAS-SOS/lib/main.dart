import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app.dart';
import 'core/services/theme_service.dart';
import 'providers/report_provider.dart';
import 'providers/adoption_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Configurar orientación de la app
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  // Modo de desarrollo con servicios mock
  print('Aplicación iniciada en modo de desarrollo con servicios mock');
  
  // Inicializar SharedPreferences para el tema y configuraciones
  final prefs = await SharedPreferences.getInstance();
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ThemeService(prefs),
        ),
        ChangeNotifierProvider(
          create: (_) => ReportProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => AdoptionProvider(),
        ),
      ],
      child: const MascotaSOSApp(),
    ),
  );
}
