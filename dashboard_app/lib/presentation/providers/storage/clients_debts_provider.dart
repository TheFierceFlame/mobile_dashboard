import 'package:dashboard_app/domain/repositories/local_storage_repository.dart';
import 'package:dashboard_app/presentation/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dashboard_app/domain/entities/client.dart';
import 'package:dashboard_app/domain/entities/debt.dart';

final storageClientsDebtsProvider = StateNotifierProvider<StorageClientsDebtsNotifier, List<Debt>>((ref) {
  final localStorageRepository = ref.watch(clientsLocalStorageRepositoryProvider);
  
  return StorageClientsDebtsNotifier(localStorageRepository: localStorageRepository);
});

final storageClientsProvider = StateNotifierProvider<StorageClientsNotifier, List<Client>>((ref) {
  final localStorageRepository = ref.watch(clientsLocalStorageRepositoryProvider);
  
  return StorageClientsNotifier(localStorageRepository: localStorageRepository);
});

class StorageClientsNotifier extends StateNotifier<List<Client>> {
  final ClientsLocalStorageRepository localStorageRepository;

  StorageClientsNotifier({
    required this.localStorageRepository
  }): super([]);

  Future<void> insertClient(Client client) async {
    await localStorageRepository.insertClient(client);

    state.add(client);
  }

  Future<List<Client>> loadClients() async {
    final clients = await localStorageRepository.loadClients();

    state = clients;

    return clients;
  }
}

class StorageClientsDebtsNotifier extends StateNotifier<List<Debt>> {
  final ClientsLocalStorageRepository localStorageRepository;

  StorageClientsDebtsNotifier({
    required this.localStorageRepository
  }): super([]);

  Future<void> insertClientDebt(Debt debt, Client client) async {
    await localStorageRepository.insertClientDebt(debt, client);

    state.add(debt);
  }

  Future<List<Debt>> loadClientsDebts() async {
    final debts = await localStorageRepository.loadClientsDebts();

    state = debts;

    return debts;
  }

  Future<void> payDebt(int debtId, double amount) async {
    await localStorageRepository.payDebt(debtId, amount);
  }
}