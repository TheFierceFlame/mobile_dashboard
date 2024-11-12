import 'package:isar/isar.dart';
import 'package:dashboard_app/domain/entities/debt.dart';
part 'client.g.dart';

@collection
class Client {
  Id id = Isar.autoIncrement;
  final String name;
  final double phone;
  final debts = IsarLinks<Debt>();

  Client({
    required this.name,
    required this.phone,
  });
}