// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'showcase_routes.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
      $showcaseRoute,
      $offlineBlockRoute,
    ];

RouteBase get $showcaseRoute => GoRouteData.$route(
      path: '/home',
      factory: $ShowcaseRouteExtension._fromState,
    );

extension $ShowcaseRouteExtension on ShowcaseRoute {
  static ShowcaseRoute _fromState(GoRouterState state) => const ShowcaseRoute();

  String get location => GoRouteData.$location(
        '/home',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $offlineBlockRoute => GoRouteData.$route(
      path: '/offline-block',
      factory: $OfflineBlockRouteExtension._fromState,
    );

extension $OfflineBlockRouteExtension on OfflineBlockRoute {
  static OfflineBlockRoute _fromState(GoRouterState state) =>
      const OfflineBlockRoute();

  String get location => GoRouteData.$location(
        '/offline-block',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}
