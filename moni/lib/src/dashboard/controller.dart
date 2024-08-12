import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'service.dart';
enum Ranking { S, A, B }

class DashboardController with ChangeNotifier {
  DashboardController(this._dashboardService);

  final DashboardService _dashboardService;
  late int _amount;

  int get amount => _amount;

  formattedAmount(int? amount) { 
    NumberFormat formatter = NumberFormat.currency(
      locale: 'vi_VN', // Vietnamese locale
      symbol: '₫', // Vietnamese Dong symbol
      decimalDigits: 0, // No decimal places for VND
    );
    String formattedAmount = formatter.format(amount);
    return formattedAmount;
  }
  

  updateToDayAmount(int? value) {
    if (value == null) return;
    _amount = value;
    _dashboardService.saveData(value);
    notifyListeners();
  }

  Future<int?> loadTodayAmount() async {
    int? amount = await _dashboardService.loadData();
    _amount = amount ?? 0;
    return amount;
  }

  remainDayOfMonth() {
    DateTime now = DateTime.now();
    DateTime firstDayOfNextMonth = DateTime(now.year, now.month + 1, 1);
    DateTime lastDayOfMonth =
        firstDayOfNextMonth.subtract(const Duration(days: 1));
    int remainingDays = lastDayOfMonth.difference(now).inDays;
    return remainingDays;
  }

  moneyForEachDayOfRemain() {
    return (_amount / remainDayOfMonth()).round();
  }

  Ranking ranking() {
    if (moneyForEachDayOfRemain() <= 100000) {
      return Ranking.B;
    }
    
    if (moneyForEachDayOfRemain() <= 500000) {
      return Ranking.A;
    }
    
    return Ranking.S;
  }

  rankingText() {
    switch (ranking()) {
      case Ranking.S:
        return 'Rank S: Excellent ';
      case Ranking.A:
        return 'Rank A: Good';
      case Ranking.B:
        return 'Rank B: Risk';
    }
  }
}
