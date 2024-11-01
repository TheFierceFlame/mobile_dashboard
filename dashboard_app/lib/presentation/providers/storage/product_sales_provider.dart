import 'package:dashboard_app/domain/repositories/local_storage_repository.dart';
import 'package:dashboard_app/presentation/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dashboard_app/domain/entities/product.dart';

final storageProductsSalesProvider = StateNotifierProvider<StorageProductsSalesNotifier, List<Product>>((ref) {
  final localStorageRepository = ref.watch(localStorageRepositoryProvider);
  
  return StorageProductsSalesNotifier(localStorageRepository: localStorageRepository);
});

class StorageProductsSalesNotifier extends StateNotifier<List<Product>> {
  final LocalStorageRepository localStorageRepository;

  StorageProductsSalesNotifier({
    required this.localStorageRepository
  }): super([]);

  Future<List<Product>> loadSales() async {
    final products = await localStorageRepository.loadProductSales();

    state = products;

    return products;
  }

  Future<void> insertProduct(Product product) async { 
    await localStorageRepository.insertProductSale(product);

    state.add(product);
  }
}