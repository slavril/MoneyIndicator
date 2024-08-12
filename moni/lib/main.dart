import 'package:flutter/material.dart';

import 'src/app.dart';
import 'src/dashboard/controller.dart';
import 'src/dashboard/service.dart';

void main() async {
  // Set up the SettingsController, which will glue user settings to multiple
  // Flutter Widgets.
  final dashboardController = DashboardController(DashboardService());

  // Load the user's preferred theme while the splash screen is displayed.
  // This prevents a sudden theme change when the app is first displayed.
  await dashboardController.loadTodayAmount();

  // Run the app and pass in the SettingsController. The app listens to the
  // SettingsController for changes, then passes it further down to the
  // SettingsView.
  runApp(MyApp(dashboardController: dashboardController));
}
