import 'package:local_storage/local_storage.dart';
import 'package:test/test.dart';
import 'package:work_orders_data/work_orders_data.dart';

class _Remote implements WorkOrdersRemoteDataSource {
  bool online = false;
  final items = <WorkOrdersItemDto>[];
  @override
  Future<List<WorkOrdersItemDto>> fetchAll() async {
    if (!online) throw StateError('offline');
    return List.unmodifiable(items);
  }

  @override
  Future<WorkOrdersItemDto> save(WorkOrdersItemDto item) async {
    if (!online) throw StateError('offline');
    items.add(item);
    return item;
  }
}

void main() {
  test('keeps local write pending, then syncs after recovery', () async {
    final local = KeyValueWorkOrdersLocalDataSource(MemoryKeyValueStore());
    final remote = _Remote();
    final repository = WorkOrdersRepositoryImpl(local, remote);
    await repository.createItem('Inspect unit');
    expect((await local.readAll()).single.pendingSync, isTrue);
    remote.online = true;
    await repository.synchronize();
    expect((await local.readAll()).single.pendingSync, isFalse);
  });
}
