import 'package:intl/intl.dart';

String todayDate() {
  var now = DateTime.now();
  return formatDate(now);
}

String formatDate(date) {
  return DateFormat('h:mm a EEE, MMM d, yyyy').format(date);
}
