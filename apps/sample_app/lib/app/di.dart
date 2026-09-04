import 'package:app_connectivity/app_connectivity.dart';
import 'package:app_logging/app_logging.dart';
import 'package:app_overlay/app_overlay.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:local_storage/local_storage.dart';
import 'package:local_storage_shared_preferences/local_storage_shared_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutorial_engine/tutorial_engine.dart';

import 'config/app_config.dart';
import 'config/app_env.dart';
import 'features/sample/sample_di.dart';
import 'features/onboarding/onboarding_di.dart';
import 'router/app_router.dart';
// scaffold:feature-imports

final sl = GetIt.instance;

Future<void> register() async {
  final prefs = await SharedPreferences.getInstance();
  final localStore = SharedPreferencesKeyValueStore(prefs);
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

  await registerSampleDependencies(sl);
  await registerOnboardingDependencies(sl);
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
