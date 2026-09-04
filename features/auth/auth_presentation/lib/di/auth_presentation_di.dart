import 'package:injectable/injectable.dart';
import 'package:auth_domain/auth_domain.dart';

@InjectableInit.microPackage(
  throwOnMissingDependencies: true,
  ignoreUnregisteredTypes: [LoginUseCase, SignupUseCase],
)
void initAuthPresentationModule() {}
