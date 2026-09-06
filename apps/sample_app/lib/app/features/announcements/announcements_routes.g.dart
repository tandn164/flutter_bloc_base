// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'announcements_routes.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
      $announcementsRoute,
    ];

RouteBase get $announcementsRoute => GoRouteData.$route(
      path: '/announcements',
      factory: $AnnouncementsRouteExtension._fromState,
    );

extension $AnnouncementsRouteExtension on AnnouncementsRoute {
  static AnnouncementsRoute _fromState(GoRouterState state) =>
      const AnnouncementsRoute();

  String get location => GoRouteData.$location(
        '/announcements',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}
