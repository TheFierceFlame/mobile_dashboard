import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dashboard_app/presentation/providers/analytics/sales/sales_provider.dart';

final initialLoadingProvider = Provider<bool>((ref) {
  final step1 = ref.watch(dailySalesProvider).isEmpty;
  final step2 = ref.watch(weeklySalesProvider).isEmpty;
  final step3 = ref.watch(monthlySalesProvider).isEmpty;
  final step4 = ref.watch(topSellingProductsProvider).isEmpty;
  final step5 = ref.watch(topBuyingCustomersProvider).isEmpty;
  //print(step5);
  if(step1 || step2 || step3 || step4 || step5) return true;

  return false;
});