import 'package:injectable/injectable.dart';
import 'package:work_orders_domain/work_orders_domain.dart';

@InjectableInit.microPackage(
    throwOnMissingDependencies: true,
    ignoreUnregisteredTypes: [WorkOrdersRepository])
void initWorkOrdersDomainModule() {}
