import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:work_orders_data/di/work_orders_data_di.module.dart';
import 'package:work_orders_domain/di/work_orders_domain_di.module.dart';
import 'package:work_orders_presentation/di/work_orders_presentation_di.module.dart';

import 'work_orders_di.config.dart';

@InjectableInit(
  initializerName: 'initWorkOrdersFeature',
  generateForDir: ['lib/app/features/work_orders'],
  includeMicroPackages: false,
  externalPackageModulesBefore: [
    ExternalModule(WorkOrdersDataPackageModule),
    ExternalModule(WorkOrdersDomainPackageModule),
    ExternalModule(WorkOrdersPresentationPackageModule),
  ],
)
Future<void> registerWorkOrdersDependencies(GetIt container) =>
    container.initWorkOrdersFeature();
