import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dashboard_app/domain/entities/product.dart';
import 'package:dashboard_app/presentation/providers/analytics/products/products_repository_provider.dart';

final productsSalesProvider = StateNotifierProvider<_ProductsNotifier, List<Product>>((ref) {
  final fetchProducts = ref.watch(productsRepositoryProvider).getProductsSales;

  return _ProductsNotifier(fetchProducts: fetchProducts);
});

typedef _SalesCallback = Future<List<Product>> Function();

class _ProductsNotifier extends StateNotifier<List<Product>> {  
  bool isLoading = false;
  _SalesCallback fetchProducts;

  _ProductsNotifier({
    required this.fetchProducts,
  }): super([]);

  Future<void> loadData() async{
    if (isLoading) return;

    isLoading = true;

    final List<Product> products = await fetchProducts();
    
    state = products;
    
    await Future.delayed(const Duration(milliseconds: 300));
    isLoading = false;
  }
}