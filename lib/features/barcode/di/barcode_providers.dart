import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../../../core/config/app_config.dart';
import '../../../core/networking/api_client.dart';
import '../data/mock_barcode_scanner.dart';
import '../data/product_api.dart';
import '../data/product_repository_impl.dart';
import '../domain/repositories/product_repository.dart';
import '../domain/services/barcode_scanner.dart';
import '../presentation/barcode_controller.dart';
import '../presentation/barcode_state.dart';

final appConfigProvider = Provider<AppConfig>((ref) {
  return const AppConfig(apiBaseUrl: 'http://10.0.2.2:3000');
});

final httpClientProvider = Provider<http.Client>((ref) {
  final client = http.Client();
  ref.onDispose(client.close);
  return client;
});

final apiClientProvider = Provider<ApiClient>((ref) {
  final config = ref.watch(appConfigProvider);
  final client = ref.watch(httpClientProvider);
  return ApiClient(baseUrl: config.apiBaseUrl, client: client);
});

final productApiProvider = Provider<ProductApi>((ref) {
  return ProductApi(ref.watch(apiClientProvider));
});

final productRepositoryProvider = Provider<ProductRepository>((ref) {
  return ProductRepositoryImpl(ref.watch(productApiProvider));
});

final barcodeScannerProvider = Provider<BarcodeScanner>((ref) {
  return MockBarcodeScanner([
    '5901234123457',
    '4006381333931',
    '4601234567890',
  ]);
});

final barcodeControllerProvider =
    StateNotifierProvider<BarcodeController, BarcodeState>((ref) {
  return BarcodeController(
    repository: ref.watch(productRepositoryProvider),
    scanner: ref.watch(barcodeScannerProvider),
  );
});
