import 'package:shared_preferences/shared_preferences.dart';

class DashboardService {
  Future<void> saveData(String key, int amount) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(key, amount);
  }

  Future<int?> loadData(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? amount = prefs.getInt(key);
    return amount;
  }

  Future<void> saveAmount(int amount) async {
    await saveData('amount', amount);
  }

  Future<int?> loadAmount() async {
    int? amount = await loadData('amount');
    return amount;
  }
}
