import 'package:injectable/injectable.dart';
import 'package:sample_domain/sample_domain.dart';

@InjectableInit.microPackage(
  throwOnMissingDependencies: true,
  ignoreUnregisteredTypes: [
    GetSample,
    CreateSampleItem,
    UpdateSampleItem,
    DeleteSampleItem
  ],
)
void initSamplePresentationModule() {}
