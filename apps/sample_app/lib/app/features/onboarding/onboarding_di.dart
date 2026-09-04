import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:onboarding_data/di/onboarding_data_di.module.dart';
import 'package:onboarding_domain/di/onboarding_domain_di.module.dart';
import 'onboarding_di.config.dart';

Future<void> registerOnboardingDependencies(GetIt sl,
        {String environment = 'local'}) =>
    configureOnboardingDependencies(sl, environment: environment);

@InjectableInit(
  initializerName: 'initOnboardingFeature',
  generateForDir: ['lib/app/features/onboarding'],
  includeMicroPackages: false,
  externalPackageModulesBefore: [
    ExternalModule(OnboardingDataPackageModule),
    ExternalModule(OnboardingDomainPackageModule),
  ],
)
Future<void> configureOnboardingDependencies(GetIt container,
    {String environment = 'local'}) async {
  await container.initOnboardingFeature(environment: environment);
}
