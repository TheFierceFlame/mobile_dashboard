import 'package:isar/isar.dart';
import 'package:dashboard_app/domain/entities/debt.dart';
part 'client.g.dart';

@collection
class Client {
  Id id = Isar.autoIncrement;
  final String name;
  final String phone;
  final String location;
  final debts = IsarLinks<Debt>();

  Client({
    required this.name,
    required this.phone,
    required this.location
  });
}