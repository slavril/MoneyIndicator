import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'service.dart';

enum Ranking { S, A, B, C }

class DashboardController with ChangeNotifier {
  DashboardController(this._dashboardService);

  final DashboardService _dashboardService;
  int? _amount;
  int? _fullCharge;

  int? get amount => _amount;

  formattedAmount(int? amount) {
    NumberFormat formatter = NumberFormat.currency(
      locale: 'vi_VN', // Vietnamese locale
      symbol: '₫', // Vietnamese Dong symbol
      decimalDigits: 0, // No decimal places for VND
    );
    String formattedAmount = formatter.format(amount);
    return formattedAmount;
  }

  updateToDayAmount(int? value, bool recharge) {
    if (value == null) return;
    _amount = value;
    _dashboardService.saveAmount(value);
    if (recharge == true && value > _fullCharge!) {
      _dashboardService.saveData('fullCharge', value);
    }
  }

  Future<int?> loadTodayAmount() async {
    int? amount = await _dashboardService.loadAmount();
    int? fullCharge = await _dashboardService.loadData('fullCharge');
    _amount = (amount ?? 0);
    _fullCharge = (fullCharge ?? 0);
    return amount;
  }

  remainDaysOfMonth() {
    DateTime now = DateTime.now();
    DateTime firstDayOfNextMonth = DateTime(now.year, now.month + 1, 1);
    DateTime lastDayOfMonth =
        firstDayOfNextMonth.subtract(const Duration(days: 1));
    int remainingDays = lastDayOfMonth.difference(now).inDays;
    return remainingDays;
  }

  moneyForEachDayOfRemain() {
    return ((_amount ?? 0) / remainDaysOfMonth()).round();
  }

  Ranking ranking() {
    if (moneyForEachDayOfRemain() <= 300000) {
      return Ranking.C;
    }

    if (moneyForEachDayOfRemain() <= 600000) {
      return Ranking.B;
    }

    if (moneyForEachDayOfRemain() <= 1000000) {
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
        return 'Rank B: Average';
      case Ranking.C:
        return 'Rank B: Risk';
    }
  }

  double batteryUsage() {
    if (_amount != null && _fullCharge != null && _fullCharge! > 0) {
      return (100 * _amount! / _fullCharge!);
    }

    return 0;
  }
}
