import 'package:intl/intl.dart';

class ConvertTimeToMinutes {
  static String formatTimeAgo(String date) {
    final DateTime fetchTime = DateTime.parse(date).toLocal();
    final DateTime now = DateTime.now();
    final Duration difference = now.difference(fetchTime);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks ${weeks == 1 ? "week" : "weeks"} ago';
    }
  }

  static String formatDate(String date) {
    final DateTime fetchDate = DateTime.parse(date).toLocal();
    final DateFormat formatter = DateFormat('MMM dd, yyyy');
    return formatter.format(fetchDate);
  }
}
