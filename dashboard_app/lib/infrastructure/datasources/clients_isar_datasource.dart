import 'dart:convert';
import 'package:dashboard_app/domain/datasources/local_storage_datasource.dart';
import 'package:dashboard_app/domain/entities/product.dart';
import 'package:dashboard_app/infrastructure/mappers/json_client_mapper.dart';
import 'package:dashboard_app/infrastructure/models/json/json_client.dart';
import 'package:dashboard_app/domain/entities/client.dart';
import 'package:dashboard_app/domain/entities/debt.dart';
import 'package:dashboard_app/domain/entities/payment.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
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
          ProductSchema,
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

    await isar.writeTxn(() async {
      await isar.clients.put(client);
    });
  }

  @override
  Future<void> insertClientDebt(Debt debt, Client client) async {
    final isar = await db;
    
    await isar.writeTxn(() async {
      debt.client.value = client;
      await isar.debts.put(debt);
        
      client.debts.add(debt);
      await isar.clients.put(client);
        
      await client.debts.save();
      await debt.client.save();
    });
  }

  @override
  Future<List<Client>> loadClients() async {
    final isar = await db;
    var count = await isar.clients.count();

    if(count == 0) {
      final jsonResponse = json.decode(await rootBundle.loadString('assets/data/clients/clients_debts_dataset.json'));

      for (int iteration = 0; iteration < jsonResponse.length; iteration++) {
        var jsonClient = JSONClient.fromJSON(jsonResponse[iteration]);
        
        await isar.writeTxn(() async {
          await isar.clients.put(ClientMapper.jsonProductToEntity(jsonClient));
        });

        for (int cicle = 0; cicle < jsonClient.debts.length; cicle++) {
          final client = await isar.clients.get(iteration + 1);
          
          final Debt debt = Debt(
            motive: jsonClient.debts[0]['motive'],
            amount: jsonClient.debts[0]['amount'],
            lastPaymentDate: DateFormat("yyyy-MM-dd HH:mm:ss").parse(jsonClient.debts[0]['date'].toString().replaceAll('T', ' '))
          );

          await insertClientDebt(debt, client!);
        }
      }
    }

    return await isar.clients.where().findAll();
  }

  @override
  Future<List<Debt>> loadClientsDebts() async {
    final clientsData = await loadClients();
    List<Debt> debtsData = [];

    if (clientsData.isEmpty) {
      return [];
    } 
    else {
      for (var client in clientsData) {
        await client.debts.load();

        final debts = client.debts.toList();
        
        for (var debt in debts) {
          debtsData.add(debt);
        }
      }

      return debtsData;
    }
  }

  @override
  Future<void> payDebt(int debtId, double amount) async {
    final isar = await db;
    final debt = await isar.debts.get(debtId);
    
    if (debt != null) {
      debt.payment += amount;
      debt.lastPaymentDate = DateTime.now();
      
      await isar.writeTxn(() async {
        await isar.debts.put(debt);
      });
      
      final payment = Payment(
        amount: amount,
        date: DateTime.now(),
        debt: debt,
      );

      await isar.writeTxn(() async {
        await isar.payments.put(payment);
      });
    }
  }
}