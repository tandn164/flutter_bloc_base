// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_catalog_routes.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
      $serviceCatalogRoute,
    ];

RouteBase get $serviceCatalogRoute => GoRouteData.$route(
      path: '/catalog',
      factory: $ServiceCatalogRouteExtension._fromState,
    );

extension $ServiceCatalogRouteExtension on ServiceCatalogRoute {
  static ServiceCatalogRoute _fromState(GoRouterState state) =>
      const ServiceCatalogRoute();

  String get location => GoRouteData.$location(
        '/catalog',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}
