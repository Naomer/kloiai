import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/pricing_model.dart';

final pricingRepoProvider = Provider((ref) => PricingRepository());

class PricingRepository {
  Future<PricingModel> fetchPricing() async {
    await Future.delayed(const Duration(milliseconds: 300));

    return PricingModel(
      monthlyPrice: 9.99,
      yearlyPrice: 79.99,
      yearlyDiscountPercent: 33,
    );
  }
}

