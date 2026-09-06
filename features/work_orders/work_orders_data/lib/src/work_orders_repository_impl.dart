import 'package:injectable/injectable.dart';
import 'package:work_orders_domain/work_orders_domain.dart';

import 'work_orders_data_sources.dart';
import 'work_orders_item_dto.dart';

@LazySingleton(as: WorkOrdersRepository)
class WorkOrdersRepositoryImpl implements WorkOrdersRepository {
  WorkOrdersRepositoryImpl(this._local, this._remote);

  final WorkOrdersLocalDataSource _local;
  final WorkOrdersRemoteDataSource _remote;

  @override
  Stream<List<WorkOrdersItem>> watchItems() => _local.watchAll().map(
        (items) => [for (final item in items) item.toEntity()],
      );

  @override
  Future<void> synchronize() async {
    final local = await _local.readAll();
    for (final pending in local.where((item) => item.pendingSync)) {
      final saved = await _remote.save(pending.copyWith(pendingSync: false));
      await _local.upsert(saved.copyWith(pendingSync: false));
    }
    final remote = await _remote.fetchAll();
    final pending = (await _local.readAll()).where((item) => item.pendingSync);
    await _local.replaceAll([
      ...pending,
      for (final item in remote) item.copyWith(pendingSync: false),
    ]);
  }

  @override
  Future<void> createItem(String title) async {
    final item = WorkOrdersItemDto(
      id: 'local-${DateTime.now().microsecondsSinceEpoch}',
      title: title.trim(),
      pendingSync: true,
    );
    await _local.upsert(item);
    await _trySave(item);
  }

  @override
  Future<void> setCompleted(String id, bool completed) async {
    final items = await _local.readAll();
    final matches = items.where((item) => item.id == id);
    if (matches.isEmpty) return;
    final changed = matches.first.copyWith(
      completed: completed,
      pendingSync: true,
    );
    await _local.upsert(changed);
    await _trySave(changed);
  }

  Future<void> _trySave(WorkOrdersItemDto item) async {
    try {
      final saved = await _remote.save(item.copyWith(pendingSync: false));
      await _local.upsert(saved.copyWith(pendingSync: false));
    } catch (_) {
      // The visible local mutation remains pending until synchronize().
    }
  }
}
