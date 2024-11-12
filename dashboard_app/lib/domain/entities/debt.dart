import 'package:isar/isar.dart';
import 'package:dashboard_app/domain/entities/client.dart';
part 'debt.g.dart';

@collection
class Debt {
  Id id = Isar.autoIncrement;
  final String motive;
  final double amount;
  double payment = 0.0;
  DateTime lastPaymentDate;
  bool active = true;
  final client = IsarLink<Client>();

  Debt({
    required this.motive,
    required this.amount,
    required this.lastPaymentDate, 
  });
}