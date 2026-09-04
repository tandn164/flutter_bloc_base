import 'package:injectable/injectable.dart';
import 'package:local_storage/local_storage.dart';

@InjectableInit.microPackage(
  throwOnMissingDependencies: true,
  ignoreUnregisteredTypes: [KeyValueStore],
)
void initOnboardingDataModule() {}
