import 'package:shared_preferences/shared_preferences.dart';

class DashboardService {

  Future<void> saveData(int amount) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('amount', amount);
  }

  Future<int?> loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? amount = prefs.getInt('amount');
    return amount;
  }
}
