import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart'; // Import Hive
import '../../../../core/api_service.dart';
import '../../../../core/service_locator.dart';
import '../../data/product_model.dart';

abstract class ProductState {}
class ProductInitial extends ProductState {}
class ProductLoading extends ProductState {}
class ProductLoaded extends ProductState {
  final List<ProductModel> products;
  ProductLoaded(this.products);
}
class ProductError extends ProductState {
  final String message;
  ProductError(this.message);
}

class ProductCubit extends Cubit<ProductState> {
  ProductCubit() : super(ProductInitial());

  Future<void> fetchProducts() async {
    emit(ProductLoading());
    try {
      // 1. Ambil data dari API
      final response = await sl<ApiService>().dio.get('/products');
      final data = response.data as List;
      
      // 2. REACTIVE DB: Simpan ke Hive (Offline First)
      var box = Hive.box('offline_products');
      await box.clear(); // Bersihkan cache lama
      
      for (var item in data) {
        await box.add({
          'title': "${item['title']} [Diskon 10%]", // Logika NIM Ganjil kamu
          'price': item['price'],
          'image': item['image'],
        });
      }
      
      // 3. Ubah ke List Model untuk UI
      final products = data.map((e) => ProductModel.fromMap(e)).toList();
      emit(ProductLoaded(products));

    } catch (e) {
      // 4. OFFLINE MODE: Jika internet mati, ambil dari Hive
      var box = Hive.box('offline_products');
      if (box.isNotEmpty) {
        final offlineData = box.values.map((e) {
          return ProductModel(
            id: 0,
            title: e['title'],
            price: (e['price'] as num).toDouble(),
            image: e['image'] ?? '',
          );
        }).toList();
        emit(ProductLoaded(offlineData));
      } else {
        emit(ProductError("Koneksi gagal dan tidak ada data lokal."));
      }
    }
  }
}