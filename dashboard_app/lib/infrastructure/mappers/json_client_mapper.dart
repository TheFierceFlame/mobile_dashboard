import 'package:dashboard_app/domain/entities/client.dart';
import 'package:dashboard_app/infrastructure/models/json/json_client.dart';

class ClientMapper {
  static Client jsonProductToEntity(JSONClient jsonClient) => Client(
    name: jsonClient.name,
    phone: jsonClient.phone,
    location: jsonClient.location,
  );
}