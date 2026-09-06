import 'package:app_navigation/app_navigation.dart';
import 'package:app_logging/app_logging.dart';
import 'package:go_router/go_router.dart';

import '../di.dart';
import '../features/onboarding/onboarding_routes.dart';
import '../features/showcase/showcase_routes.dart';
import '../features/announcements/announcements_routes.dart';
import '../features/service_catalog/service_catalog_routes.dart';
import '../features/work_orders/work_orders_routes.dart';
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
          createServiceCatalogBranch(sl),
          createAnnouncementsBranch(sl),
          createWorkOrdersBranch(sl),
          // scaffold:feature-branches
        ],
      ),
    ],
  );
}
