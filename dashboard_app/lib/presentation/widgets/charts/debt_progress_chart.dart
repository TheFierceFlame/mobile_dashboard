import 'package:flutter/material.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';
import 'package:dashboard_app/domain/entities/debt.dart';

class DebtProgressChart extends StatelessWidget {
  final double totalDebt;
  final List<Debt> clientsDebtsData;

  const DebtProgressChart({
    super.key,
    required this.totalDebt,
    required this.clientsDebtsData
  });

  double _getOpenDebt(List<Debt> debts) {
    double total = 0;

    for (var debt in debts) {
      total += debt.amount;
    }
    
    return total;
  }

  @override
  Widget build(BuildContext context) {
    final percentage = (_getOpenDebt(clientsDebtsData) / totalDebt) * 100;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SimpleCircularProgressBar(
          valueNotifier: ValueNotifier(percentage),
          mergeMode: true,
          animationDuration: 1,
          onGetText: (double value) {
            return Text(
              '${value.toInt()}%',
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            );
          },
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}