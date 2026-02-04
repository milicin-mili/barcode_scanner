import '../domain/entities/product.dart';

class BarcodeState {
  const BarcodeState({
    required this.lastBarcode,
    required this.product,
    required this.isLoading,
    required this.errorMessage,
  });

  final String? lastBarcode;
  final Product? product;
  final bool isLoading;
  final String? errorMessage;

  factory BarcodeState.initial() {
    return const BarcodeState(
      lastBarcode: null,
      product: null,
      isLoading: false,
      errorMessage: null,
    );
  }

  BarcodeState copyWith({
    String? lastBarcode,
    Product? product,
    bool? isLoading,
    String? errorMessage,
  }) {
    return BarcodeState(
      lastBarcode: lastBarcode ?? this.lastBarcode,
      product: product ?? this.product,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}
