import '../domain/entities/product.dart';
import '../domain/entities/size_availability.dart';

class ProductDto {
  ProductDto({
    required this.barcode,
    required this.name,
    required this.imageUrl,
    required this.sizes,
  });

  final String barcode;
  final String name;
  final String imageUrl;
  final List<SizeAvailabilityDto> sizes;

  factory ProductDto.fromJson(Map<String, dynamic> json) {
    final sizesJson = (json['sizes'] as List<dynamic>? ?? [])
        .whereType<Map<String, dynamic>>()
        .toList();

    return ProductDto(
      barcode: json['barcode'] as String,
      name: json['name'] as String,
      imageUrl: json['imageUrl'] as String,
      sizes: sizesJson.map(SizeAvailabilityDto.fromJson).toList(),
    );
  }

  Product toDomain() {
    return Product(
      barcode: barcode,
      name: name,
      imageUrl: imageUrl,
      sizes: sizes.map((item) => item.toDomain()).toList(),
    );
  }
}

class SizeAvailabilityDto {
  SizeAvailabilityDto({
    required this.size,
    required this.qty,
  });

  final String size;
  final int qty;

  factory SizeAvailabilityDto.fromJson(Map<String, dynamic> json) {
    return SizeAvailabilityDto(
      size: json['size'] as String,
      qty: json['qty'] as int,
    );
  }

  SizeAvailability toDomain() {
    return SizeAvailability(size: size, qty: qty);
  }
}
