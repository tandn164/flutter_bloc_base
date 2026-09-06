import 'package:injectable/injectable.dart';
import 'package:local_storage/local_storage.dart';
import '../src/work_orders_data_sources.dart';

@InjectableInit.microPackage(
  throwOnMissingDependencies: true,
  ignoreUnregisteredTypes: [
    KeyValueStore,
    WorkOrdersLocalDataSource,
    WorkOrdersRemoteDataSource,
  ],
)
void initWorkOrdersDataModule() {}
