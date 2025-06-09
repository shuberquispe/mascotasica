import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

class DateFormatter {
  // Formatear fecha completa (ej: 01 de Junio de 2025)
  static String formatFullDate(DateTime date) {
    final DateFormat formatter = DateFormat('dd \'de\' MMMM \'de\' yyyy', 'es');
    return formatter.format(date);
  }
  
  // Formatear fecha corta (ej: 01/06/2025)
  static String formatShortDate(DateTime date) {
    final DateFormat formatter = DateFormat('dd/MM/yyyy');
    return formatter.format(date);
  }
  
  // Formatear hora (ej: 15:30)
  static String formatTime(DateTime date) {
    final DateFormat formatter = DateFormat('HH:mm');
    return formatter.format(date);
  }
  
  // Formatear fecha y hora (ej: 01/06/2025 15:30)
  static String formatDateTime(DateTime date) {
    final DateFormat formatter = DateFormat('dd/MM/yyyy HH:mm');
    return formatter.format(date);
  }
  
  // Formatear tiempo relativo (ej: hace 5 minutos, hace 2 horas)
  static String formatTimeAgo(DateTime date) {
    // Configurar mensajes en español
    timeago.setLocaleMessages('es', timeago.EsMessages());
    return timeago.format(date, locale: 'es');
  }
  
  // Formatear para calendario (ej: Lun, 01 Jun)
  static String formatCalendarDay(DateTime date) {
    final DateFormat formatter = DateFormat('E, dd MMM', 'es');
    return formatter.format(date);
  }
  
  // Formatear mes y año (ej: Junio 2025)
  static String formatMonthYear(DateTime date) {
    final DateFormat formatter = DateFormat('MMMM yyyy', 'es');
    return formatter.format(date);
  }
  
  // Obtener nombre del día de la semana
  static String getDayName(DateTime date) {
    final DateFormat formatter = DateFormat('EEEE', 'es');
    return formatter.format(date).capitalize();
  }
  
  // Obtener nombre del mes
  static String getMonthName(DateTime date) {
    final DateFormat formatter = DateFormat('MMMM', 'es');
    return formatter.format(date).capitalize();
  }
}

// Extensión para capitalizar strings
extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
