import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio = Dio();

  ApiService() {
    // Menambahkan Interceptor (Syarat wajib: Logging)
    _dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
    ));
    
    _dio.options.baseUrl = "https://fakestoreapi.com";
  }

  Dio get dio => _dio;
}