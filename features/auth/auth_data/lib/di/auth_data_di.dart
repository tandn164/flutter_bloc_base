import 'package:injectable/injectable.dart';
import 'package:chopper/chopper.dart';
import 'package:api_client/api_client.dart';
import '../auth_data.dart';

@InjectableInit.microPackage(
  throwOnMissingDependencies: true,
  ignoreUnregisteredTypes: [
    ChopperClient,
    ApiTransport,
    TokenVault,
    TokenRefresher,
    AuthSessionConfig
  ],
)
void initAuthDataModule() {}
