import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dashboard_app/domain/entities/sale.dart';
import 'package:dashboard_app/presentation/providers/analytics/sales/sales_repository_provider.dart';

final dailySalesProvider = StateNotifierProvider<_SalesNotifier, List<Sale>>((ref) {
  final fetchSales = ref.watch(salesRepositoryProvider).getDailySales;

  return _SalesNotifier(fetchSales: fetchSales);
});

final weeklySalesProvider = StateNotifierProvider<_SalesNotifier, List<Sale>>((ref) {
  final fetchSales = ref.watch(salesRepositoryProvider).getWeeklySales;

  return _SalesNotifier(fetchSales: fetchSales);
});

final monthlySalesProvider = StateNotifierProvider<_SalesNotifier, List<Sale>>((ref) {
  final fetchSales = ref.watch(salesRepositoryProvider).getMonthlySales;

  return _SalesNotifier(fetchSales: fetchSales);
});

final topSellingProductsProvider = StateNotifierProvider<_SalesNotifier, List<Sale>>((ref) {
  final fetchSales = ref.watch(salesRepositoryProvider).getTopSellingProducts;

  return _SalesNotifier(fetchSales: fetchSales);
});

final topBuyingCustomersProvider = StateNotifierProvider<_SalesNotifier, List<Sale>>((ref) {
  final fetchSales = ref.watch(salesRepositoryProvider).getTopBuyingCustomers;

  return _SalesNotifier(fetchSales: fetchSales);
});

typedef _SalesCallback = Future<List<Sale>> Function(List<dynamic>);

class _SalesNotifier extends StateNotifier<List<Sale>> {  
  bool isLoading = false;
  _SalesCallback fetchSales;

  _SalesNotifier({
    required this.fetchSales,
  }): super([]);

  Future<void> loadData(List<dynamic> salesFilters) async{
    if (isLoading) return;

    isLoading = true;

    final List<Sale> sales = await fetchSales(salesFilters);
    
    state = sales;
    
    await Future.delayed(const Duration(milliseconds: 300));
    isLoading = false;
  }
}