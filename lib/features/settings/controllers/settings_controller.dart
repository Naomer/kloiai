import 'dart:async';

class SettingsController {
  Future<Map<String, double>> fetchPricing() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return {
      "monthly": 15.0,
      "yearly": 150.0,
    };
  }
}

