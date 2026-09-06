//@GeneratedMicroModule;WorkOrdersDomainPackageModule;package:work_orders_domain/di/work_orders_domain_di.module.dart
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i687;

import 'package:injectable/injectable.dart' as _i526;
import 'package:work_orders_domain/src/work_orders_repository.dart' as _i319;
import 'package:work_orders_domain/src/work_orders_use_cases.dart' as _i268;

class WorkOrdersDomainPackageModule extends _i526.MicroPackageModule {
// initializes the registration of main-scope dependencies inside of GetIt
  @override
  _i687.FutureOr<void> init(_i526.GetItHelper gh) {
    gh.lazySingleton<_i268.ListWorkOrdersItems>(
        () => _i268.ListWorkOrdersItems(gh<_i319.WorkOrdersRepository>()));
    gh.lazySingleton<_i268.SynchronizeWorkOrders>(
        () => _i268.SynchronizeWorkOrders(gh<_i319.WorkOrdersRepository>()));
    gh.lazySingleton<_i268.CreateWorkOrder>(
        () => _i268.CreateWorkOrder(gh<_i319.WorkOrdersRepository>()));
    gh.lazySingleton<_i268.SetWorkOrderCompleted>(
        () => _i268.SetWorkOrderCompleted(gh<_i319.WorkOrdersRepository>()));
  }
}
