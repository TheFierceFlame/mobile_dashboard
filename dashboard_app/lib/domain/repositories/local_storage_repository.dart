import 'package:dashboard_app/domain/entities/client.dart';
import 'package:dashboard_app/domain/entities/debt.dart';
import 'package:dashboard_app/domain/entities/product.dart';

abstract class ProductsLocalStorageRepository {
  Future<void> insertProductSale(Product product);
  Future<List<Product>> loadProductSales();
  Future<List<Product>> searchProductSales(DateTime fromDate);
}

abstract class ClientsLocalStorageRepository {
  Future<void> insertClient(Client client);
  Future<void> insertClientDebt(Debt debt, Client client);
  Future<List<Client>> loadClients();
  Future<List<Debt>> loadClientsDebts();
  Future<void> payDebt(int debtId, double amount);
}