import '../domain/entities/product.dart';
import '../domain/repositories/product_repository.dart';
import 'product_api.dart';

class ProductRepositoryImpl implements ProductRepository {
  ProductRepositoryImpl(this._api);

  final ProductApi _api;

  @override
  Future<Product> getProduct(String barcode) async {
    final dto = await _api.fetchProduct(barcode);
    return dto.toDomain();
  }
}
