//@GeneratedMicroModule;WorkOrdersPresentationPackageModule;package:work_orders_presentation/di/work_orders_presentation_di.module.dart
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i687;

import 'package:injectable/injectable.dart' as _i526;
import 'package:work_orders_domain/work_orders_domain.dart' as _i685;
import 'package:work_orders_presentation/src/work_orders_bloc.dart' as _i226;

class WorkOrdersPresentationPackageModule extends _i526.MicroPackageModule {
// initializes the registration of main-scope dependencies inside of GetIt
  @override
  _i687.FutureOr<void> init(_i526.GetItHelper gh) {
    gh.factory<_i226.WorkOrdersBloc>(() => _i226.WorkOrdersBloc(
          gh<_i685.ListWorkOrdersItems>(),
          gh<_i685.SynchronizeWorkOrders>(),
          gh<_i685.CreateWorkOrder>(),
          gh<_i685.SetWorkOrderCompleted>(),
        ));
  }
}
