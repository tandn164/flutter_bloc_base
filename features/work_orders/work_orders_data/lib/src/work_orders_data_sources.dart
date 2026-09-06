import 'dart:async';

import 'package:local_storage/local_storage.dart';

import 'work_orders_item_dto.dart';

abstract interface class WorkOrdersRemoteDataSource {
  Future<List<WorkOrdersItemDto>> fetchAll();
  Future<WorkOrdersItemDto> save(WorkOrdersItemDto item);
}

abstract interface class WorkOrdersLocalDataSource {
  Stream<List<WorkOrdersItemDto>> watchAll();
  Future<List<WorkOrdersItemDto>> readAll();
  Future<void> replaceAll(List<WorkOrdersItemDto> items);
  Future<void> upsert(WorkOrdersItemDto item);
}

class KeyValueWorkOrdersLocalDataSource implements WorkOrdersLocalDataSource {
  KeyValueWorkOrdersLocalDataSource(this._store);

  static const _key = 'work_orders.source_of_truth.v1';
  final KeyValueStore _store;
  final _changes = StreamController<List<WorkOrdersItemDto>>.broadcast();

  @override
  Stream<List<WorkOrdersItemDto>> watchAll() async* {
    yield await readAll();
    yield* _changes.stream;
  }

  @override
  Future<List<WorkOrdersItemDto>> readAll() async {
    final raw = await _store.readString(_key);
    if (raw == null || raw.isEmpty) return [];
    return WorkOrdersItemDto.listFromJson(raw);
  }

  @override
  Future<void> replaceAll(List<WorkOrdersItemDto> items) => _write(items);

  @override
  Future<void> upsert(WorkOrdersItemDto item) async {
    final items = await readAll();
    final index = items.indexWhere((value) => value.id == item.id);
    if (index < 0) {
      items.insert(0, item);
    } else {
      items[index] = item;
    }
    await _write(items);
  }

  Future<void> _write(List<WorkOrdersItemDto> items) async {
    await _store.writeString(_key, WorkOrdersItemDto.listToJson(items));
    _changes.add(List.unmodifiable(items));
  }
}
