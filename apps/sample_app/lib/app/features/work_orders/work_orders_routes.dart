import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:work_orders_presentation/work_orders_presentation.dart';

part 'work_orders_routes.g.dart';

@TypedGoRoute<WorkOrdersRoute>(path: '/work-orders')
class WorkOrdersRoute extends GoRouteData {
  const WorkOrdersRoute();
  @override
  Widget build(BuildContext context, GoRouterState state) =>
      throw UnsupportedError('Mounted through the app shell');
}

StatefulShellBranch createWorkOrdersBranch(GetIt sl) => StatefulShellBranch(
      routes: [
        GoRoute(
          path: const WorkOrdersRoute().location,
          builder: (_, __) => WorkOrdersPage(
            createBloc: () => sl<WorkOrdersBloc>(),
          ),
        ),
      ],
    );
