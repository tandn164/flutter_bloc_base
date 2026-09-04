//@GeneratedMicroModule;AuthPresentationPackageModule;package:auth_presentation/di/auth_presentation_di.module.dart
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i687;

import 'package:auth_domain/auth_domain.dart' as _i470;
import 'package:auth_presentation/src/auth_callbacks.dart' as _i147;
import 'package:auth_presentation/src/bloc/login_bloc.dart' as _i328;
import 'package:auth_presentation/src/bloc/signup_bloc.dart' as _i234;
import 'package:injectable/injectable.dart' as _i526;

class AuthPresentationPackageModule extends _i526.MicroPackageModule {
// initializes the registration of main-scope dependencies inside of GetIt
  @override
  _i687.FutureOr<void> init(_i526.GetItHelper gh) {
    gh.factoryParam<_i328.LoginBloc, _i147.OnAuthenticated, dynamic>((
      onAuthenticated,
      _,
    ) =>
        _i328.LoginBloc(
          login: gh<_i470.LoginUseCase>(),
          onAuthenticated: onAuthenticated,
        ));
    gh.factoryParam<_i234.SignupBloc, _i147.OnAuthenticated, dynamic>((
      onAuthenticated,
      _,
    ) =>
        _i234.SignupBloc(
          signup: gh<_i470.SignupUseCase>(),
          onAuthenticated: onAuthenticated,
        ));
  }
}
