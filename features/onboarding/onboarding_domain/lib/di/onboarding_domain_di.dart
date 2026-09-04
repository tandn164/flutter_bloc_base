import 'package:injectable/injectable.dart';
import '../onboarding_domain.dart';

@InjectableInit.microPackage(
  throwOnMissingDependencies: true,
  ignoreUnregisteredTypes: [OnboardingRepository],
)
void initOnboardingDomainModule() {}
