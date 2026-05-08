class ProductModel {
  final int id;
  final String title;
  final double price;
  final String description;
  final String category;
  final String image;

  ProductModel({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
  });

  // Factory untuk merubah JSON dari API menjadi Object Flutter
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      // LOGIKA PERSONAL: Tambahkan [Diskon 10%] karena NIM Ganjil (1)
      title: "${json['title']} [Diskon 10%]", 
      price: (json['price'] as num).toDouble(),
      description: json['description'],
      category: json['category'],
      image: json['image'],
    );
  }
}