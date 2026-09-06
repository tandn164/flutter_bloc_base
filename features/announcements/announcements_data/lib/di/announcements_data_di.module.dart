//@GeneratedMicroModule;AnnouncementsDataPackageModule;package:announcements_data/di/announcements_data_di.module.dart
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i687;

import 'package:announcements_data/src/announcements_remote_data_source.dart'
    as _i222;
import 'package:announcements_data/src/announcements_repository_impl.dart'
    as _i402;
import 'package:announcements_domain/announcements_domain.dart' as _i217;
import 'package:injectable/injectable.dart' as _i526;

class AnnouncementsDataPackageModule extends _i526.MicroPackageModule {
// initializes the registration of main-scope dependencies inside of GetIt
  @override
  _i687.FutureOr<void> init(_i526.GetItHelper gh) {
    gh.lazySingleton<_i217.AnnouncementsRepository>(() =>
        _i402.AnnouncementsRepositoryImpl.create(
            gh<_i222.AnnouncementsRemoteDataSource>()));
  }
}
