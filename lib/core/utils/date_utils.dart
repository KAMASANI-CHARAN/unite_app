import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DateUtils {
  static String formatDate(dynamic timestamp) {
    if (timestamp == null) return 'TBD';
    if (timestamp is DateTime) {
      return DateFormat.yMMMd().format(timestamp);
    }
    if (timestamp is Timestamp) {
      return DateFormat.yMMMd().format(timestamp.toDate());
    }
    return timestamp.toString();
  }
}
