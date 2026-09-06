import 'package:app_connectivity/app_connectivity.dart';
import 'package:app_logging/app_logging.dart';
import 'package:app_overlay/app_overlay.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/widgets.dart';
import 'package:local_storage/local_storage.dart';
import 'package:local_storage_drift/local_storage_drift.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutorial_engine/tutorial_engine.dart';
import 'package:announcements_data/announcements_data.dart';
import 'package:service_catalog_data/service_catalog_data.dart';
import 'package:work_orders_data/work_orders_data.dart';

import 'config/app_config.dart';
import 'config/app_env.dart';
import 'features/onboarding/onboarding_di.dart';
import 'features/announcements/announcements_di.dart';
import 'features/service_catalog/service_catalog_di.dart';
import 'features/work_orders/work_orders_di.dart';
import 'demo/field_operations_api.dart';
import 'router/app_router.dart';

// scaffold:feature-imports
final sl = GetIt.instance;

Future<void> register({KeyValueStore? localStoreOverride}) async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final localStore =
      localStoreOverride ?? DriftKeyValueStore.defaults(name: 'sample_app');
  final connectivity = MutableConnectivityHint();
  final log = BufferedLogService(
    LogQueue(max: 500),
    alsoPrint: AppEnv.flavor != 'prod',
  );

  sl
    ..registerLazySingleton(() => const AppConfig(flavor: AppEnv.flavor))
    ..registerSingleton(prefs)
    ..registerSingleton<KeyValueStore>(localStore)
    ..registerSingleton(connectivity)
    ..registerSingleton<ConnectivityHint>(connectivity)
    ..registerSingleton<LogSink>(log)
    ..registerSingleton<LogReader>(log);

  if (localStore is DriftKeyValueStore) {
    sl.registerSingleton<DriftKeyValueStore>(
      localStore,
      dispose: (database) => database.close(),
    );
  }

  final fieldApi = FieldOperationsSampleApi(connectivity);
  sl
    ..registerSingleton<ServiceCatalogRemoteDataSource>(fieldApi)
    ..registerSingleton<AnnouncementsRemoteDataSource>(fieldApi)
    ..registerSingleton<WorkOrdersRemoteDataSource>(fieldApi)
    ..registerLazySingleton<WorkOrdersLocalDataSource>(
      () => KeyValueWorkOrdersLocalDataSource(localStore),
    );

  await registerOnboardingDependencies(sl);
  await registerServiceCatalogDependencies(sl);
  await registerAnnouncementsDependencies(sl);
  await registerWorkOrdersDependencies(sl);
  // scaffold:feature-registrations
  _registerOverlay();
}

void _registerOverlay() {
  sl
    ..registerLazySingleton<TutorialStore>(() {
      final prefs = sl<SharedPreferences>();
      return CallbackTutorialStore(
        read: (key) => prefs.getBool(key) ?? false,
        write: (key, value) async {
          await prefs.setBool(key, value);
        },
      );
    })
    ..registerLazySingleton(
      () => OverlayController(
        connectivity: sl(),
        defaultPageConfig: PageConfig(
          noInternet: sl<AppConfig>().defaultNoInternet,
        ),
        tutorialController: TutorialController(store: sl()),
      ),
    )
    ..registerLazySingleton<OverlayFeedback>(() => sl<OverlayController>())
    ..registerLazySingleton<GoRouter>(createRouter);
}
