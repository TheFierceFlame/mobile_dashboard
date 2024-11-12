import 'package:dashboard_app/domain/datasources/local_storage_datasource.dart';
import 'package:dashboard_app/domain/entities/client.dart';
import 'package:dashboard_app/domain/entities/debt.dart';
import 'package:dashboard_app/domain/entities/payment.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class ClientsIsarDatasource extends ClientsLocalStorageDatasource {
  late Future<Isar> db;

  ClientsIsarDatasource() {
    db = openDB();
  }

  Future<Isar> openDB() async {
    final dir = await getApplicationDocumentsDirectory();
    
    if (Isar.instanceNames.isEmpty) {
      return await Isar.open(
        [
          ClientSchema,
          DebtSchema,
          PaymentSchema
        ],
        inspector: true,
        directory: dir.path
      );
    }

    return Future.value(Isar.getInstance());
  }

  @override
  Future<void> insertClient(Client client) async {
    final isar = await db;

    isar.writeTxnSync(() => isar.clients.putSync(client));
  }

  @override
  Future<void> insertClientDebt(Debt debt, Client client) async {
    final isar = await db;
    
    isar.writeTxnSync(() {
      debt.client.value = client;
      isar.debts.putSync(debt);
        
      client.debts.add(debt);
      isar.clients.putSync(client);
        
      client.debts.save();
      debt.client.save();
    });
  }

  @override
  Future<List<Client>> loadClients() async {
    final isar = await db;

    return isar.clients.where().findAll();
  }

  @override
  Future<List<Debt>> loadClientDebts(int clientId) async {
    final isar = await db;
    final client = await isar.clients.get(clientId);

    if (client == null) {
      return [];
    } 
    else {
      client.debts.load();

      return client.debts.toList();
    }
  }

  @override
  Future<void> payDebt(int debtId, double amount) async {
    final isar = await db;
    final debt = await isar.debts.get(debtId);
    
    if (debt != null) {
      debt.payment += amount;
      debt.lastPaymentDate = DateTime.now();
      
      isar.writeTxnSync(() {
        isar.debts.putSync(debt);
      });
      
      final payment = Payment(
        amount: amount,
        date: DateTime.now(),
        debt: debt,
      );

      isar.writeTxnSync(() => isar.payments.put(payment));
    }
  }
}