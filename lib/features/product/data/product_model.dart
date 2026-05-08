class ProductModel {
  final int id;
  final String title;
  final double price;
  final String image;

  ProductModel({
    required this.id,
    required this.title,
    required this.price,
    required this.image,
  });

  // Pastikan namanya 'fromMap' agar sesuai dengan pemanggilan di Cubit
  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'] ?? 0,
      // Logika NIM Ganjil tetap terjaga
      title: "${map['title']} [Diskon 10%]",
      price: (map['price'] as num).toDouble(),
      image: map['image'] ?? '',
    );
  }
}