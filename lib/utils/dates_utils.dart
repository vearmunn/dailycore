import 'package:intl/intl.dart';

enum Priority { none, low, medium, high }

String formattedDate(DateTime date) {
  return DateFormat('dd MMM yyyy').format(date);
}

String formattedDate2(DateTime date) {
  final formatted = DateFormat('d MMMM').format(date);
  String today = '$formatted${whatIsTheDay(date)}${dayName(date)}';

  return today;
}

String formattedDate3(DateTime date) {
  return DateFormat('dd MMMM yyyy').format(date);
}

String formattedDateAndTime(DateTime date) {
  final formatted = DateFormat('d MMMM yyyy - HH:mm').format(date);

  return formatted;
}

String formatTime(DateTime date) {
  final formatted = DateFormat('HH:mm').format(date);
  return formatted;
}

String formatMonthYear(DateTime date) {
  final formatted = DateFormat('MMMM yyyy').format(date);
  return formatted;
}

String whatIsTheDay(DateTime date) {
  String theDayIs = '';
  if (date.year == DateTime.now().year &&
      date.month == DateTime.now().month &&
      date.day == DateTime.now().day) {
    theDayIs = ' • Today';
  } else if (date.year == DateTime.now().year &&
      date.month == DateTime.now().month &&
      date.day == DateTime.now().day + 1) {
    theDayIs = ' • Tomorrow';
  } else {
    theDayIs = '';
  }

  return theDayIs;
}

String dayName(DateTime date) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final target = DateTime(date.year, date.month, date.day);
  final difference = target.difference(today).inDays;

  if (difference >= 0 && difference <= 6) {
    return ' • ${DateFormat.EEEE().format(date)}';
  } else {
    return '';
  }
}
