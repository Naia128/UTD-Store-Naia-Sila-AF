import 'package:get_it/get_it.dart';
import 'api_service.dart';
import 'websocket_service.dart';
import '../features/splash/domain/splash_service.dart';

final sl = GetIt.instance;

Future<void> setupLocator() async {
  // Core & Networking
  sl.registerLazySingleton(() => ApiService());
  
  // Real-time Websocket & Concurrency
  sl.registerLazySingleton(() => WebsocketService());

  // Services
  sl.registerLazySingleton(() => SplashService());
}