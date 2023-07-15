import 'package:intl/intl.dart';

String formatDate(DateTime? date) =>
    date != null ? DateFormat('d MMMM y', 'ru').format(date) : '';
