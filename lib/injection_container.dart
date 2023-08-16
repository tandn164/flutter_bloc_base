import 'package:chopper/chopper.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/network/rest_client_service.dart';

final sl = GetIt.instance;

//Dependency injection
Future<void> init() async {
  //External
  final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => InternetConnectionChecker());
  final client = ChopperClient(interceptors: [
    CurlInterceptor(),
    HttpLoggingInterceptor(),
  ]);
  sl.registerLazySingleton(() => RestClientService.create(client));
}
