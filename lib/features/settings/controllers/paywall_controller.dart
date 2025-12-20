import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/pricing_repository.dart';
import '../models/pricing_model.dart';

final paywallControllerProvider =
    StateNotifierProvider<PaywallController, PricingState>((ref) {
  return PaywallController(ref.read(pricingRepoProvider));
});

class PaywallController extends StateNotifier<PricingState> {
  final PricingRepository repo;

  PaywallController(this.repo) : super(PricingState.loading()) {
    loadPricing();
  }

  Future<void> loadPricing() async {
    final pricing = await repo.fetchPricing();
    state = PricingState.loaded(pricing);
  }

  void togglePlan() {
    state = state.copyWith(
      isYearly: !state.isYearly,
    );
  }
}

class PricingState {
  final bool isLoading;
  final bool isYearly;
  final PricingModel? pricing;

  PricingState({
    required this.isLoading,
    required this.isYearly,
    required this.pricing,
  });

  factory PricingState.loading() =>
      PricingState(isLoading: true, isYearly: false, pricing: null);

  factory PricingState.loaded(PricingModel pricing) =>
      PricingState(isLoading: false, isYearly: false, pricing: pricing);

  PricingState copyWith({
    bool? isLoading,
    bool? isYearly,
    PricingModel? pricing,
  }) {
    return PricingState(
      isLoading: isLoading ?? this.isLoading,
      isYearly: isYearly ?? this.isYearly,
      pricing: pricing ?? this.pricing,
    );
  }
}

