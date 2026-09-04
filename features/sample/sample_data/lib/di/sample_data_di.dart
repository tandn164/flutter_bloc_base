import 'package:api_client/api_client.dart';
import 'package:injectable/injectable.dart';

@InjectableInit.microPackage(
  throwOnMissingDependencies: true,
  ignoreUnregisteredTypes: [DataGateway],
)
void initSampleDataModule() {}
