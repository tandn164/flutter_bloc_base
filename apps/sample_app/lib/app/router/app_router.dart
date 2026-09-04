import 'package:app_navigation/app_navigation.dart';
import 'package:app_logging/app_logging.dart';
import 'package:go_router/go_router.dart';

import '../di.dart';
import '../features/onboarding/onboarding_routes.dart';
import '../features/showcase/showcase_routes.dart';
import '../features/sample/sample_routes.dart';
import 'app_shell.dart';
// scaffold:feature-imports

GoRouter createRouter({LogSink? logSink}) {
  final sink = logSink ?? (sl.isRegistered<LogSink>() ? sl<LogSink>() : null);

  return GoRouter(
    initialLocation: const ShowcaseRoute().location,
    observers: [
      if (sink != null) LogNavObserver(sink),
    ],
    routes: [
      ...createOnboardingRoutes(sl),
      ...createShowcaseRoutes(),
      // scaffold:feature-routes
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) => AppShell(navigationShell: shell),
        branches: [
          createShowcaseBranch(sl),
          createSampleBranch(sl),
          // scaffold:feature-branches
        ],
      ),
    ],
  );
}
