// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:announcements_data/di/announcements_data_di.module.dart'
    as _i25;
import 'package:announcements_domain/di/announcements_domain_di.module.dart'
    as _i147;
import 'package:announcements_presentation/di/announcements_presentation_di.module.dart'
    as _i761;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> initAnnouncementsFeature({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    await _i25.AnnouncementsDataPackageModule().init(gh);
    await _i147.AnnouncementsDomainPackageModule().init(gh);
    await _i761.AnnouncementsPresentationPackageModule().init(gh);
    return this;
  }
}
