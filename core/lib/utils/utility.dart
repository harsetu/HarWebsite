import 'package:core/utils/user_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/date_format_constants.dart';

class Utility {

  //TODO need to see after clear do we need to navigate to login screen
  static Future<void> logoutUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();

    // Clear secure storage as well
    await UserSecureStorage.clearUserData();
  }

  static String formatDueDate(String? date) {
    if (date != null && date.isNotEmpty) {
      DateTime? dueDate = DateTime.tryParse(date);
      if (dueDate != null) {
        String formattedDate = DateFormat(
          DateFormatConstants.ddmmmhhmma,
        ).format(dueDate);
        return formattedDate;
      }
    }
    return '';
  }

  static String formatIndianCurrency(int amount) {
    String formattedCurrency = NumberFormat('##,##,##,###').format(amount);
    return '₹ $formattedCurrency';
  }

  static String formatDate(DateTime date) {
    // Define the date format you want
    final formatter = DateFormat(DateFormatConstants.ddmmyyyy);
    // Format the date
    return formatter.format(date);
  }
}
