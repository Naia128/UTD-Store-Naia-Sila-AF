import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/api_service.dart';
import '../../data/product_model.dart';
import '../../../../core/service_locator.dart';

// State sederhana: Loading, Success, Error
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
      final api = sl<ApiService>();
      final response = await api.dio.get('/products');
      
      if (response.statusCode == 200) {
        final List data = response.data;
        final products = data.map((e) => ProductModel.fromMap(e)).toList();
        emit(ProductLoaded(products));
      } else {
        emit(ProductError("Gagal mengambil data"));
      }
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }
}