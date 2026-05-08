import 'package:get_it/get_it.dart';
import 'api_service.dart';
import '../features/splash/domain/splash_service.dart';

final sl = GetIt.instance;

void setupLocator() {
  sl.registerLazySingleton(() => ApiService());
  sl.registerLazySingleton(() => SplashService());
}