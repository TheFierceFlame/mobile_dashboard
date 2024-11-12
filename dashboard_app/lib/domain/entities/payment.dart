import 'package:isar/isar.dart';
import 'package:dashboard_app/domain/entities/debt.dart';
part 'payment.g.dart';

@collection
class Payment {
  Id id = Isar.autoIncrement;
  final double amount;
  final DateTime date;
  final debt = IsarLink<Debt>();

  Payment({
    required this.amount,
    required this.date,
    Debt? debt,
  }) {
    if (debt != null) {
      this.debt.value = debt;
    }
  }
}