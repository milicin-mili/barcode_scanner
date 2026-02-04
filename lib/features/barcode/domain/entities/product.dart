import 'size_availability.dart';

class Product {
  const Product({
    required this.barcode,
    required this.name,
    required this.imageUrl,
    required this.sizes,
  });

  final String barcode;
  final String name;
  final String imageUrl;
  final List<SizeAvailability> sizes;
}
