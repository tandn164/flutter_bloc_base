import 'package:injectable/injectable.dart';
import '../sample_domain.dart';

@InjectableInit.microPackage(
  throwOnMissingDependencies: true,
  ignoreUnregisteredTypes: [SampleRepository],
)
void initSampleDomainModule() {}
