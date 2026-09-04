import 'package:injectable/injectable.dart';
import 'package:profile_domain/profile_domain.dart';

@InjectableInit.microPackage(
  throwOnMissingDependencies: true,
  ignoreUnregisteredTypes: [GetProfile, UpdateProfile],
)
void initProfilePresentationModule() {}
