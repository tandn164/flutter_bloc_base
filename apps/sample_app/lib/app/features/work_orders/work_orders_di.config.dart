// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:work_orders_data/di/work_orders_data_di.module.dart' as _i567;
import 'package:work_orders_domain/di/work_orders_domain_di.module.dart'
    as _i277;
import 'package:work_orders_presentation/di/work_orders_presentation_di.module.dart'
    as _i552;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> initWorkOrdersFeature({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    await _i567.WorkOrdersDataPackageModule().init(gh);
    await _i277.WorkOrdersDomainPackageModule().init(gh);
    await _i552.WorkOrdersPresentationPackageModule().init(gh);
    return this;
  }
}
