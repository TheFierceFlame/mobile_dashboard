import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dashboard_app/domain/entities/debt.dart';
import 'package:dashboard_app/presentation/screens/analytics/debtors/debtors_tracking_screen.dart';
import 'package:dashboard_app/presentation/providers/providers.dart';
import 'package:dashboard_app/presentation/widgets/widgets.dart';
import 'package:intl/intl.dart';

double totalDebt = 0;

class DebtorsAnalyticsScreen extends ConsumerStatefulWidget {
  const DebtorsAnalyticsScreen({super.key});

  @override
  DebtorsAnalyticsScreenState createState() => DebtorsAnalyticsScreenState();
}

class DebtorsAnalyticsScreenState extends ConsumerState<DebtorsAnalyticsScreen> {
  _getTotalDebt(List<Debt> clientsDebts) {
    for(var debt in clientsDebts) {
      totalDebt += debt.amount;
    }
  }

  _addPayment(int debtId, double amount) async {
    await ref.read(storageClientsDebtsProvider.notifier).payDebt(debtId, amount);
    await ref.read(storageClientsDebtsProvider.notifier).loadClientsDebts();
    setState(() {});
  }

  _showPaymentModal(BuildContext context, int debtId, Function callBack) {
    final paymentController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter bottomSheetState) {
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
                      onPressed: () {
                        final amount = double.tryParse(paymentController.text);
            
                        if (amount == null || amount < 0) return;
                          
                        callBack(debtId, amount);
                        bottomSheetState(() {
                          Navigator.pop(context);
                        });
                      },
                      child: const Text('Abonar'),
                    ),
                  ),
                ],
              ),
            );
          }
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    ref.read(storageClientsDebtsProvider.notifier).loadClientsDebts();
  }

  @override
  Widget build(BuildContext context) {
    final clientsDebts = ref.watch(storageClientsDebtsProvider);

    if(clientsDebts.isEmpty) return const CircularProgressIndicator();
    
    _getTotalDebt(clientsDebts);

    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        backgroundColor: Colors.orange[900],
        centerTitle: true,
        title: const Text(
          'Deudas por cobrar',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18
          ),
        ),
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
                    child: Column(
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
                              onTap: () => _showPaymentModal(context, debt.id, _addPayment),
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
                  )
                ),
              )
            ],
          )
        ),
      ),
      floatingActionButton: Container(
        margin: const EdgeInsets.only(bottom: 60),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              heroTag: "FloatingActionButtonTracking",
              foregroundColor: Colors.white,
              backgroundColor: Colors.indigo[900],
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) {
                    return DebtorsTrackingScreen(clientsDebts: clientsDebts);
                  })
                );
              },
              child: const Icon(Icons.map_outlined),
            )
          ],
        ),
      ),
    );
  }
}