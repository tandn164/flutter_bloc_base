import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:service_catalog_presentation/service_catalog_presentation.dart';

part 'service_catalog_routes.g.dart';

@TypedGoRoute<ServiceCatalogRoute>(path: '/catalog')
class ServiceCatalogRoute extends GoRouteData {
  const ServiceCatalogRoute();
  @override
  Widget build(BuildContext context, GoRouterState state) =>
      throw UnsupportedError('Mounted through the app shell');
}

StatefulShellBranch createServiceCatalogBranch(GetIt sl) => StatefulShellBranch(
      routes: [
        GoRoute(
          path: const ServiceCatalogRoute().location,
          builder: (_, __) => ServiceCatalogPage(
            createBloc: () => sl<ServiceCatalogBloc>(),
          ),
        ),
      ],
    );
