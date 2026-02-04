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

  Future<void> scan() async {
    final barcode = _scanner.scan();

    state = state.copyWith(
      lastBarcode: barcode,
      product: null,
      errorMessage: null,
      isLoading: true,
    );

    if (barcode.isEmpty) {
      state = state.copyWith(
        errorMessage: 'Нет доступных штрихкодов для сканирования.',
        isLoading: false,
      );
      return;
    }

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
