import 'package:flutter/material.dart';
import '../presentation/screens/auth/login_screen.dart';
import '../presentation/screens/auth/register_screen.dart';
import '../presentation/screens/auth/forgot_password_screen.dart';
import '../presentation/screens/home/home_screen.dart';
import '../presentation/screens/splash/splash_screen.dart';
import '../presentation/screens/onboarding/onboarding_screen.dart';
import '../presentation/screens/reports/report_form_screen.dart';
import '../presentation/screens/reports/report_detail_screen.dart';
import '../presentation/screens/adoptions/adoptions_list_screen.dart';
import '../presentation/screens/adoptions/adoption_detail_screen.dart';
import '../presentation/screens/adoptions/adoption_form_screen.dart';
import '../presentation/screens/adoptions/adoption_requests_screen.dart';

class AppRoutes {
  // Nombres de rutas
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String home = '/home';
  
  // Rutas para reportes
  static const String reportsList = '/reports';
  static const String reportDetail = '/reports/detail';
  static const String reportForm = '/reports/form';
  
  // Rutas para adopciones
  static const String adoptionsList = '/adoptions';
  static const String adoptionDetail = '/adoptions/detail';
  static const String adoptionForm = '/adoptions/form';
  static const String adoptionRequests = '/adoptions/requests';
  
  // Rutas para cuidados (comentadas temporalmente)
  static const String myPets = '/my-pets';
  static const String petProfile = '/my-pets/profile';
  static const String careCalendar = '/care/calendar';
  static const String guides = '/guides';
  static const String guideDetail = '/guides/detail';
  
  // Rutas para servicios (comentadas temporalmente)
  static const String servicesMap = '/services';
  static const String serviceDetail = '/services/detail';
  
  // Rutas para foro (comentadas temporalmente)
  static const String forum = '/forum';
  static const String postDetail = '/forum/detail';
  static const String createPost = '/forum/create';
  
  // Rutas para perfil (comentadas temporalmente)
  static const String profile = '/profile';
  static const String settings = '/settings';

  // Generador de rutas
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Extraer argumentos si existen
    final args = settings.arguments;

    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case onboarding:
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case register:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case forgotPassword:
        return MaterialPageRoute(builder: (_) => const ForgotPasswordScreen());
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      
      // Rutas para reportes
      case reportsList:
        // Pantalla temporalmente no disponible
        return MaterialPageRoute(builder: (_) => const Scaffold(
          body: Center(child: Text('Pantalla de lista de reportes en desarrollo')),
        ));
      case reportDetail:
        return MaterialPageRoute(
          builder: (_) => ReportDetailScreen(reportId: args as String),
        );
      case reportForm:
        return MaterialPageRoute(
          builder: (_) => ReportFormScreen(reportType: args as String),
        );
      
      // Rutas para adopciones
      case adoptionsList:
        return MaterialPageRoute(builder: (_) => const AdoptionsListScreen());
      case adoptionDetail:
        return MaterialPageRoute(
          builder: (_) => AdoptionDetailScreen(adoptionId: args as String),
        );
      case adoptionForm:
        return MaterialPageRoute(builder: (_) => const AdoptionFormScreen());
      case adoptionRequests:
        return MaterialPageRoute(
          builder: (_) => AdoptionRequestsScreen(adoptionId: args as String),
        );
      
      // Rutas para cuidados (temporalmente deshabilitadas)
      case myPets:
      case petProfile:
      case careCalendar:
      case guides:
      case guideDetail:
        return MaterialPageRoute(builder: (_) => const Scaffold(
          body: Center(child: Text('Funcionalidad en desarrollo')),
        ));
      
      // Rutas para servicios (temporalmente deshabilitadas)
      case servicesMap:
      case serviceDetail:
        return MaterialPageRoute(builder: (_) => const Scaffold(
          body: Center(child: Text('Funcionalidad en desarrollo')),
        ));
      
      // Rutas para foro (temporalmente deshabilitadas)
      case forum:
      case postDetail:
      case createPost:
        return MaterialPageRoute(builder: (_) => const Scaffold(
          body: Center(child: Text('Funcionalidad en desarrollo')),
        ));
      
      // Rutas para perfil (temporalmente deshabilitadas)
      case profile:
      case AppRoutes.settings:
        return MaterialPageRoute(builder: (_) => const Scaffold(
          body: Center(child: Text('Funcionalidad en desarrollo')),
        ));
      
      // Ruta por defecto
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('Ruta no encontrada: ${settings.name}'),
            ),
          ),
        );
    }
  }
}
