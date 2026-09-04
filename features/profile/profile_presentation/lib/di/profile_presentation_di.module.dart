//@GeneratedMicroModule;ProfilePresentationPackageModule;package:profile_presentation/di/profile_presentation_di.module.dart
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i687;

import 'package:injectable/injectable.dart' as _i526;
import 'package:profile_domain/profile_domain.dart' as _i952;
import 'package:profile_presentation/src/bloc/profile_bloc.dart' as _i111;
import 'package:profile_presentation/src/profile_callbacks.dart' as _i999;

class ProfilePresentationPackageModule extends _i526.MicroPackageModule {
// initializes the registration of main-scope dependencies inside of GetIt
  @override
  _i687.FutureOr<void> init(_i526.GetItHelper gh) {
    gh.factoryParam<_i111.ProfileBloc, _i999.OnProfileSignOut, dynamic>((
      onSignOut,
      _,
    ) =>
        _i111.ProfileBloc(
          getProfile: gh<_i952.GetProfile>(),
          updateProfile: gh<_i952.UpdateProfile>(),
          onSignOut: onSignOut,
        ));
  }
}
