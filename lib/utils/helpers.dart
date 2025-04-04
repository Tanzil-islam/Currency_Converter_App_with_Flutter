import 'package:intl/intl.dart';

class Helpers {
  // Format currency with symbol
  static String formatCurrency(double amount, String currencyCode) {
    return NumberFormat.currency(
      symbol: currencyCode,
      decimalDigits: 2,
    ).format(amount);
  }
  
  // Format currency without symbol
  static String formatNumber(double amount) {
    return NumberFormat.decimalPattern().format(amount);
  }
  
  // Format date
  static String formatDate(DateTime date) {
    return DateFormat('MMM dd, yyyy HH:mm').format(date);
  }
  
  // Format timeAgo from timestamp
  static String timeAgo(int timestamp) {
    final DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    final Duration difference = DateTime.now().difference(date);
    
    if (difference.inDays > 0) {
      return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
    } else {
      return 'Just now';
    }
  }
}