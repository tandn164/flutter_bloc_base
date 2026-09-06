//@GeneratedMicroModule;WorkOrdersDataPackageModule;package:work_orders_data/di/work_orders_data_di.module.dart
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i687;

import 'package:injectable/injectable.dart' as _i526;
import 'package:work_orders_data/src/work_orders_data_sources.dart' as _i295;
import 'package:work_orders_data/src/work_orders_repository_impl.dart' as _i179;
import 'package:work_orders_domain/work_orders_domain.dart' as _i685;

class WorkOrdersDataPackageModule extends _i526.MicroPackageModule {
// initializes the registration of main-scope dependencies inside of GetIt
  @override
  _i687.FutureOr<void> init(_i526.GetItHelper gh) {
    gh.lazySingleton<_i685.WorkOrdersRepository>(
        () => _i179.WorkOrdersRepositoryImpl(
              gh<_i295.WorkOrdersLocalDataSource>(),
              gh<_i295.WorkOrdersRemoteDataSource>(),
            ));
  }
}
