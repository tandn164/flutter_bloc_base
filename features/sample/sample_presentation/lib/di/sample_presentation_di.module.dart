//@GeneratedMicroModule;SamplePresentationPackageModule;package:sample_presentation/di/sample_presentation_di.module.dart
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i687;

import 'package:injectable/injectable.dart' as _i526;
import 'package:sample_domain/sample_domain.dart' as _i180;
import 'package:sample_presentation/src/bloc/sample_bloc.dart' as _i34;

class SamplePresentationPackageModule extends _i526.MicroPackageModule {
// initializes the registration of main-scope dependencies inside of GetIt
  @override
  _i687.FutureOr<void> init(_i526.GetItHelper gh) {
    gh.factory<_i34.SampleBloc>(() => _i34.SampleBloc(
          getSample: gh<_i180.GetSample>(),
          createItem: gh<_i180.CreateSampleItem>(),
          updateItem: gh<_i180.UpdateSampleItem>(),
          deleteItem: gh<_i180.DeleteSampleItem>(),
        ));
  }
}
