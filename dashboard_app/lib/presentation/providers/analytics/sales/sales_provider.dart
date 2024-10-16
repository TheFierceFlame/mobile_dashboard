import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dashboard_app/domain/entities/sale.dart';
import 'package:dashboard_app/presentation/providers/analytics/sales/sales_repository_provider.dart';

final dailySalesProvider = StateNotifierProvider<SalesNotifier, List<Sale>>((ref) {
  final fetchSales = ref.watch(salesRepositoryProvider).getDailySales;

  return SalesNotifier(fetchSales: fetchSales);
});

typedef SalesCallback = Future<List<Sale>> Function();

class SalesNotifier extends StateNotifier<List<Sale>> {  
  bool isLoading = false;
  SalesCallback fetchSales;

  SalesNotifier({
    required this.fetchSales,
  }): super([]);

  Future<void> loadData() async{
    if (isLoading) return;

    isLoading = true;

    final List<Sale> sales = await fetchSales();
    
    state = [...state, ...sales];
    
    await Future.delayed(const Duration(milliseconds: 300));
    isLoading = false;
  }
}