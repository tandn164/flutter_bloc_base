import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:sample_data/di/sample_data_di.module.dart';
import 'package:sample_domain/di/sample_domain_di.module.dart';
import 'package:sample_presentation/di/sample_presentation_di.module.dart';
import 'sample_di.config.dart';

Future<void> registerSampleDependencies(GetIt sl,
        {String environment = 'local'}) =>
    configureSampleDependencies(sl, environment: environment);

@InjectableInit(
  initializerName: 'initSampleFeature',
  generateForDir: ['lib/app/features/sample'],
  includeMicroPackages: false,
  externalPackageModulesBefore: [
    ExternalModule(SampleDataPackageModule),
    ExternalModule(SampleDomainPackageModule),
    ExternalModule(SamplePresentationPackageModule),
  ],
)
Future<void> configureSampleDependencies(GetIt container,
    {String environment = 'local'}) async {
  await container.initSampleFeature(environment: environment);
}
