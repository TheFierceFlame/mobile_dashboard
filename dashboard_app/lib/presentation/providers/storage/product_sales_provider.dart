import 'package:dashboard_app/domain/repositories/local_storage_repository.dart';
import 'package:dashboard_app/presentation/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dashboard_app/domain/entities/product.dart';

final storageProductsSalesProvider = StateNotifierProvider<StorageProductsSalesNotifier, List<Product>>((ref) {
  final localStorageRepository = ref.watch(productsLocalStorageRepositoryProvider);
  
  return StorageProductsSalesNotifier(localStorageRepository: localStorageRepository);
});

final storageProductsSalesFiltersProvider = StateProvider<DateTime>((ref) {
  return DateTime.now();
});

class StorageProductsSalesNotifier extends StateNotifier<List<Product>> {
  final ProductsLocalStorageRepository localStorageRepository;

  StorageProductsSalesNotifier({
    required this.localStorageRepository
  }): super([]);

  Future<void> insertProduct(Product product) async { 
    await localStorageRepository.insertProductSale(product);

    state.add(product);
  }

  Future<List<Product>> loadSales() async {
    final products = await localStorageRepository.loadProductSales();

    state = products;

    return products;
  }

  Future<List<Product>> searchSales(DateTime fromDate) async {
    final products = await localStorageRepository.searchProductSales(fromDate);

    state = products;

    return products;
  }
}