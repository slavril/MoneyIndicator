import 'package:flutter/material.dart';


class BatteryIndicator extends StatelessWidget {
  final int percentage;

  final int width = 120;
  final int gap = 4;

  const BatteryIndicator({super.key, required this.percentage});

  get numberOfShapes => (percentage / 10).round();
  get numberOfShapesFullCharged => 10;

  getCorrectColor(int index, int currentUsage) {
    const risk = Color(0xFFFF4949);
    const good = Color(0xFF06D001);
    const consumed = Color(0xFFF6F1E9);

    if (index < currentUsage) {
      if (currentUsage <= 1) {
        return risk;
      }
      return good;
    }
    
    return consumed;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(gap.toDouble()),
      width: width.toDouble(),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.black),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(
          numberOfShapesFullCharged,
          (index) => Container(
            width: (width - 8 - (numberOfShapesFullCharged - 1) * 2 ) / numberOfShapesFullCharged, // Adjust width as needed
            height: 20, // Adjust height as needed
            decoration: BoxDecoration(
              color: getCorrectColor(index, numberOfShapes), // Replace with desired color
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
      ),
    );
  }
}