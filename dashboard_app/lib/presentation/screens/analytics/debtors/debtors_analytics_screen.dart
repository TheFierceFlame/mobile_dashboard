import 'package:dashboard_app/domain/entities/debt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dashboard_app/presentation/providers/providers.dart';
import 'package:dashboard_app/domain/entities/client.dart';
import 'package:dashboard_app/presentation/widgets/widgets.dart';
import 'package:intl/intl.dart';

List<Debt> clientsDebts = [];
double totalDebt = 0;

class DebtorsAnalyticsScreen extends ConsumerStatefulWidget {
  const DebtorsAnalyticsScreen({super.key});

  @override
  DebtorsAnalyticsScreenState createState() => DebtorsAnalyticsScreenState();
}

class DebtorsAnalyticsScreenState extends ConsumerState<DebtorsAnalyticsScreen> {
  final storageClientsAsync = FutureProvider<List<Client>>((ref) async {
    final clientsData = await ref.read(storageClientsProvider.notifier).loadClients();
    List<Debt> debts = [];
    double total = 0;

    for (var client in clientsData) {
      final debtsData = await ref.read(storageClientsDebtsProvider.notifier).loadClientDebts(client.id);

      for (var debt in debtsData) {
        debts.add(debt);
        total += debt.amount;
      }
    }

    clientsDebts = debts;
    totalDebt = total;

    return clientsData;
  });

  _showPaymentModal(BuildContext context, int deudaId) {
    final paymentController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: paymentController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Monto del Abono',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.7,
                child: ElevatedButton(
                  onPressed: () async {
                    final amount = double.tryParse(paymentController.text);

                    if (amount == null || amount < 0) return;
                      
                    await ref.read(storageClientsDebtsProvider.notifier).payDebt(deudaId, amount);
                    await ref.read(storageClientsProvider.notifier).loadClients();
                    setState(() {
                      Navigator.pop(context);
                    });
                  },
                  child: const Text('Abonar'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void initState() async {
    super.initState();
    ref.read(storageClientsProvider.notifier).loadClients();
  }

  @override
  Widget build(BuildContext context) {
    final clientsData = ref.watch(storageClientsAsync);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Deudas por cobrar'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height),
                    child: clientsData.when(
                      data: (clients) => Column(
                        children: [
                          const SizedBox(height: 10),
                          DebtProgressChart(
                            totalDebt: totalDebt,
                            clientsDebtsData: clientsDebts,
                          ),
                          const SizedBox(height: 10),
                          ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: clientsDebts.length,
                            itemBuilder: (context, index) {
                              final debt = clientsDebts[index];
                              final clientName = debt.client.value?.name ?? 'Cliente desconocido';

                              if(debt.payment == debt.amount) return Container();

                              return GestureDetector(
                                onTap: () => _showPaymentModal(context, debt.id),
                                child: Container(
                                  margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                                  padding: const EdgeInsets.all(10.0),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        clientName,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: Colors.black,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        'Deuda: ${debt.amount} / Abonado: ${debt.payment}',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        'Último Abono: ${DateFormat('dd/MM/yyyy').format(debt.lastPaymentDate)}',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          )
                        ],
                      ),
                      error: (_, __) => const CircularProgressIndicator(),
                      loading: () => const CircularProgressIndicator()
                    )
                  ),
                )
              )
            ],
          ),
        ),
      ),
    );
  }
}