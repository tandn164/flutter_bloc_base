//@GeneratedMicroModule;AnnouncementsPresentationPackageModule;package:announcements_presentation/di/announcements_presentation_di.module.dart
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i687;

import 'package:announcements_domain/announcements_domain.dart' as _i217;
import 'package:announcements_presentation/src/announcements_bloc.dart'
    as _i215;
import 'package:injectable/injectable.dart' as _i526;

class AnnouncementsPresentationPackageModule extends _i526.MicroPackageModule {
// initializes the registration of main-scope dependencies inside of GetIt
  @override
  _i687.FutureOr<void> init(_i526.GetItHelper gh) {
    gh.factory<_i215.AnnouncementsBloc>(() => _i215.AnnouncementsBloc(
          gh<_i217.ListAnnouncementsItems>(),
          gh<_i217.ClearAnnouncementsCache>(),
        ));
  }
}
