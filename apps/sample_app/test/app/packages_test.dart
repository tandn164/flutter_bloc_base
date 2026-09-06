import 'package:app_connectivity/app_connectivity.dart';
import 'package:app_logging/app_logging.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sample_app/app/di.dart';
import 'package:announcements_domain/announcements_domain.dart';
import 'package:service_catalog_domain/service_catalog_domain.dart';
import 'package:work_orders_data/work_orders_data.dart';
import 'package:work_orders_domain/work_orders_domain.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:local_storage/local_storage.dart';

void main() {
  setUp(() async {
    await sl.reset();
    SharedPreferences.setMockInitialValues({});
  });

  tearDown(() async => sl.reset());

  test('register wires reusable capabilities and three data strategies',
      () async {
    await register(localStoreOverride: MemoryKeyValueStore());

    expect(sl<ConnectivityHint>(), same(sl<MutableConnectivityHint>()));
    expect(sl<LogSink>(), isA<BufferedLogService>());
    expect(sl<LogReader>(), same(sl<LogSink>()));
    expect(sl<ServiceCatalogRepository>(), isNotNull);
    expect(sl<AnnouncementsRepository>(), isNotNull);
    expect(sl<WorkOrdersRepository>(), isNotNull);
    expect(sl<WorkOrdersLocalDataSource>(),
        isA<KeyValueWorkOrdersLocalDataSource>());

    sl<LogSink>().add(
      const LogEvent(kind: 'test', message: 'action', fields: {'token': 'x'}),
    );
    expect(sl<LogReader>().recent.single.fields['token'], '***');
  });
}
