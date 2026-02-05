import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/error/app_exception.dart';
import '../domain/repositories/product_repository.dart';
import '../domain/services/barcode_scanner.dart';
import 'barcode_state.dart';

class BarcodeController extends StateNotifier<BarcodeState> {
  BarcodeController({
    required ProductRepository repository,
    required BarcodeScanner scanner,
  })  : _repository = repository,
        _scanner = scanner,
        super(BarcodeState.initial());

  final ProductRepository _repository;
  final BarcodeScanner _scanner;
  bool _isScanning = false;

  Future<void> scan({BarcodeScanner? scanner}) async {
    if (state.isLoading || _isScanning) {
      return;
    }

    state = state.copyWith(errorMessage: null);

    final scannerToUse = scanner ?? _scanner;
    String? barcode;
    try {
      _isScanning = true;
      barcode = await scannerToUse.scan();
    } catch (error) {
      _isScanning = false;
      state = state.copyWith(
        errorMessage: 'Не удалось открыть камеру: $error',
        isLoading: false,
      );
      return;
    }
    _isScanning = false;

    if (barcode == null || barcode.isEmpty) {
      return;
    }

    state = BarcodeState(
      lastBarcode: barcode,
      product: null,
      errorMessage: null,
      isLoading: true,
    );

    try {
      final product = await _repository.getProduct(barcode);
      state = state.copyWith(product: product, isLoading: false);
    } on NotFoundException {
      state = state.copyWith(
        errorMessage: 'Товар с таким штрихкодом не найден.',
        isLoading: false,
      );
    } on ApiException catch (error) {
      state = state.copyWith(
        errorMessage: 'Ошибка сервера: ${error.statusCode}.',
        isLoading: false,
      );
    } catch (error) {
      state = state.copyWith(
        errorMessage: 'Не удалось получить данные: $error',
        isLoading: false,
      );
    }
  }
}
