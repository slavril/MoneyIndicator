import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:moni/src/dashboard/battery.dart';

import 'controller.dart';

class TheCard extends StatelessWidget {
  final Color indicatorColor;
  final String description;
  final String amount;
  final String amountCanSpendADay;
  final String remainDays;
  final int batteryUsage;

  const TheCard({
    super.key,
    required this.indicatorColor,
    required this.description,
    required this.amount,
    required this.amountCanSpendADay,
    required this.remainDays,
    required this.batteryUsage,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final today = DateTime.now();
    final formatter = DateFormat('dd-MM-yyyy');
    final formattedDate = formatter.format(today);

    return Card(
      child: Container(
        width: screenWidth - 32, // Subtract margin from both sides
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Color(0xFFF5F7F8),
          borderRadius: BorderRadius.all(Radius.circular(6)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: indicatorColor,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Today ($formattedDate)',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Last submitted amount: $amount',
              style: const TextStyle(fontSize: 12),
            ),
            Text(
              'Remaining days: $remainDays',
              style: const TextStyle(fontSize: 12),
            ),
            Text(
              'Amount you can spend per day: $amountCanSpendADay',
              style: const TextStyle(fontSize: 12),
            ),
            Text(
              'Battery usage: $batteryUsage%',
              style: const TextStyle(fontSize: 12),
            ),
            BatteryIndicator(percentage: batteryUsage,),
            Text(
              description,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: indicatorColor),
            ),
          ],
        ),
      ),
    );
  }
}

// ignore: must_be_immutable

class DashboardView extends StatefulWidget {
  final DashboardController controller;
  const DashboardView({super.key, required this.controller});

  @override
  State<DashboardView> createState() => _DashboardView();
}

class _DashboardView extends State<DashboardView> {
  late int? _amount = widget.controller.amount;
  // ignore: avoid_init_to_null
  String? _textAmount = null;
  @override
  Widget build(BuildContext context) {
    widget.controller.loadTodayAmount().then((value) => setState(() {
          _amount = value;
        }));
    return Scaffold(
      backgroundColor: const Color(0xFFFFB22C),
      appBar: AppBar(
        title: const Text('Moni'),
        backgroundColor: const Color(0xFFFFB22C),
      ),
      body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TheCard(
                indicatorColor: Colors.red,
                description: widget.controller.rankingText(),
                amount: _amount == null
                    ? 'loading'
                    : widget.controller.formattedAmount(_amount),
                amountCanSpendADay: widget.controller.formattedAmount(
                    widget.controller.moneyForEachDayOfRemain()),
                remainDays: widget.controller.remainDaysOfMonth().toString(),
                batteryUsage: widget.controller.batteryUsage().round(),
              ),
              const SizedBox(height: 20),
              Text(
                widget.controller
                    .formattedAmount(int.tryParse(_textAmount ?? '0') ?? 0),
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              TextField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Enter a number',
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF379777))),
                ),
                onChanged: (value) {
                  setState(() {
                    _textAmount = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              SizedBox(
                  width: double.infinity, // Or specify a fixed width
                  height: 50, // Adjust height as needed
                  child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _amount = int.parse(_textAmount!);
                          widget.controller.updateToDayAmount(_amount, false);
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF379777),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              6), // Adjust radius as needed
                        ), // Change the button color here
                      ),
                      child: const Text('Submit',
                          style: TextStyle(color: Color(0xFFF5F7F8))))),
              const SizedBox(height: 10),
              SizedBox(
                  width: double.infinity, // Or specify a fixed width
                  height: 50, // Adjust height as needed
                  child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _amount = int.parse(_textAmount!);
                          widget.controller.updateToDayAmount(_amount, true);
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 63, 126, 105),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              6), // Adjust radius as needed
                        ), // Change the button color here
                      ),
                      child: const Text('Recharge',
                          style: TextStyle(color: Color(0xFFF5F7F8))))),
            ],
          )),
    );
  }
}
