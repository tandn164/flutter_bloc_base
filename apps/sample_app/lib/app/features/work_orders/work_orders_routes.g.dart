// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'work_orders_routes.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
      $workOrdersRoute,
    ];

RouteBase get $workOrdersRoute => GoRouteData.$route(
      path: '/work-orders',
      factory: $WorkOrdersRouteExtension._fromState,
    );

extension $WorkOrdersRouteExtension on WorkOrdersRoute {
  static WorkOrdersRoute _fromState(GoRouterState state) =>
      const WorkOrdersRoute();

  String get location => GoRouteData.$location(
        '/work-orders',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}
