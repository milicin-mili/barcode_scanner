import '../../../core/networking/api_client.dart';
import 'product_dto.dart';

class ProductApi {
  ProductApi(this._client);

  final ApiClient _client;

  Future<ProductDto> fetchProduct(String barcode) async {
    final data = await _client.getJson('/products/$barcode');
    return ProductDto.fromJson(data);
  }
}
