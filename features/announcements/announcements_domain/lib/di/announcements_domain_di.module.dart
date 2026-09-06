//@GeneratedMicroModule;AnnouncementsDomainPackageModule;package:announcements_domain/di/announcements_domain_di.module.dart
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i687;

import 'package:announcements_domain/src/announcements_repository.dart'
    as _i873;
import 'package:announcements_domain/src/announcements_use_cases.dart' as _i608;
import 'package:injectable/injectable.dart' as _i526;

class AnnouncementsDomainPackageModule extends _i526.MicroPackageModule {
// initializes the registration of main-scope dependencies inside of GetIt
  @override
  _i687.FutureOr<void> init(_i526.GetItHelper gh) {
    gh.lazySingleton<_i608.ListAnnouncementsItems>(() =>
        _i608.ListAnnouncementsItems(gh<_i873.AnnouncementsRepository>()));
    gh.lazySingleton<_i608.ClearAnnouncementsCache>(() =>
        _i608.ClearAnnouncementsCache(gh<_i873.AnnouncementsRepository>()));
  }
}
