import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dashboard_app/presentation/providers/providers.dart';

final storageProductsSalesLoadingProvider = Provider<bool>((ref) {
  final step = ref.watch(storageProductsSalesProvider).isEmpty;
  
  if(step) return true;

  return false;
});