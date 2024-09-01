import 'package:intl/intl.dart';

class DateHelper{
  static String formatDate(String date) {
    final dateTime = DateTime.parse(date);
    final formattedDate = DateFormat('EEE, d MMM yyyy HH:mm').format(dateTime);
    return '$formattedDate GMT';
  }
}