import '../domain/services/barcode_scanner.dart';

class MockBarcodeScanner implements BarcodeScanner {
  MockBarcodeScanner(this._barcodes);

  final List<String> _barcodes;
  int _index = 0;

  @override
  Future<String?> scan() async {
    if (_barcodes.isEmpty) {
      return null;
    }
    final code = _barcodes[_index];
    _index = (_index + 1) % _barcodes.length;
    return code;
  }
}
