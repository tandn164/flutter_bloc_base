import 'package:app_connectivity/app_connectivity.dart';
import 'package:app_logging/app_logging.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/widgets.dart';

import '../../di.dart' as app_di;
import '../../showcase/showcase_page.dart';

part 'showcase_routes.g.dart';

@TypedGoRoute<ShowcaseRoute>(path: '/home')
class ShowcaseRoute extends GoRouteData {
  const ShowcaseRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      _page(context, app_di.sl);
}

@TypedGoRoute<OfflineBlockRoute>(path: '/offline-block')
class OfflineBlockRoute extends GoRouteData {
  const OfflineBlockRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const OfflineBlockSamplePage();
}

List<RouteBase> createShowcaseRoutes() {
  return [
    GoRoute(
      path: const OfflineBlockRoute().location,
      builder: (context, state) =>
          const OfflineBlockRoute().build(context, state),
    ),
  ];
}

StatefulShellBranch createShowcaseBranch(GetIt sl) {
  return StatefulShellBranch(
    routes: [
      GoRoute(
        path: const ShowcaseRoute().location,
        builder: (context, _) => _page(context, sl),
      ),
    ],
  );
}

Widget _page(BuildContext context, GetIt sl) => ShowcasePage(
      connectivity: sl<MutableConnectivityHint>(),
      logSink: sl<LogSink>(),
      logReader: sl<LogReader>(),
      openLocation: context.go,
    );
