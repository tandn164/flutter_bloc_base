import 'package:announcements_data/announcements_data.dart';
import 'package:announcements_domain/announcements_domain.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:sample_app/app/features/announcements/announcements_routes.dart';
import 'package:sample_app/app/features/service_catalog/service_catalog_routes.dart';
import 'package:sample_app/app/features/work_orders/work_orders_routes.dart';
import 'package:sample_app/app/router/app_router.dart';
import 'package:service_catalog_data/service_catalog_data.dart';
import 'package:service_catalog_domain/service_catalog_domain.dart';
import 'package:work_orders_data/work_orders_data.dart';
import 'package:work_orders_domain/work_orders_domain.dart';

void main() {
  test('typed routes expose all three data strategies', () {
    expect(const ServiceCatalogRoute().location, '/catalog');
    expect(const AnnouncementsRoute().location, '/announcements');
    expect(const WorkOrdersRoute().location, '/work-orders');
  });

  test('router keeps data strategies in documented tab order', () {
    final router = createRouter();
    addTearDown(router.dispose);
    final shell =
        router.configuration.routes.whereType<StatefulShellRoute>().single;
    expect(
      shell.branches.map((branch) => (branch.routes.single as GoRoute).path),
      ['/home', '/catalog', '/announcements', '/work-orders'],
    );
  });

  test('three strategies expose different repository contracts', () {
    expect(ServiceCatalogRepository, isNot(AnnouncementsRepository));
    expect(AnnouncementsRepository, isNot(WorkOrdersRepository));
    expect(
        ServiceCatalogRemoteDataSource, isNot(AnnouncementsRemoteDataSource));
    expect(WorkOrdersLocalDataSource, isNot(WorkOrdersRemoteDataSource));
  });

  test('feature branches are app composition only', () {
    final container = GetIt.asNewInstance();
    expect(createServiceCatalogBranch(container).routes, hasLength(1));
    expect(createAnnouncementsBranch(container).routes, hasLength(1));
    expect(createWorkOrdersBranch(container).routes, hasLength(1));
  });
}
