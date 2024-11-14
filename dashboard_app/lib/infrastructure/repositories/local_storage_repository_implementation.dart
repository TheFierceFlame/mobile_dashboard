import 'package:dashboard_app/domain/entities/client.dart';
import 'package:dashboard_app/domain/entities/debt.dart';
import 'package:dashboard_app/domain/entities/product.dart';
import 'package:dashboard_app/domain/datasources/local_storage_datasource.dart';
import 'package:dashboard_app/domain/repositories/local_storage_repository.dart';


class ProductsLocalStorageRepositoryImplementation extends ProductsLocalStorageRepository {
  final ProductsLocalStorageDatasource datasource;
  ProductsLocalStorageRepositoryImplementation(this.datasource);

  @override
  Future<void> insertProductSale(Product product) {
    return datasource.insertProductSale(product);
  }

  @override
  Future<List<Product>> loadProductSales() {
    return datasource.loadProductSales();
  }

  @override
  Future<List<Product>> searchProductSales(DateTime fromDate) {
    return datasource.searchProductSales(fromDate);
  }
}

class ClientsLocalStorageRepositoryImplementation extends ClientsLocalStorageRepository {
  final ClientsLocalStorageDatasource datasource;
  ClientsLocalStorageRepositoryImplementation(this.datasource);

  @override
  Future<void> insertClient(Client client) {
    return datasource.insertClient(client);
  }

  @override
  Future<void> insertClientDebt(Debt debt, Client client) {
    return datasource.insertClientDebt(debt, client);
  }

  @override
  Future<List<Client>> loadClients() {
    return datasource.loadClients();
  }

  @override
  Future<List<Debt>> loadClientsDebts() {
    return datasource.loadClientsDebts();
  }

  @override
  Future<void> payDebt(int debtId, double amount) {
    return datasource.payDebt(debtId, amount);
  }
}