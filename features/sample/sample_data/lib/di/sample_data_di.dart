import 'package:injectable/injectable.dart';
import 'package:chopper/chopper.dart';

@InjectableInit.microPackage(
  throwOnMissingDependencies: true,
  ignoreUnregisteredTypes: [ChopperClient],
)
void initSampleDataModule() {}
