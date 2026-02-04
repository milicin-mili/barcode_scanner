import '../entities/product.dart';

abstract class ProductRepository {
  Future<Product> getProduct(String barcode);
}
