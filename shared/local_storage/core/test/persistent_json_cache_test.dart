import 'package:local_storage/local_storage.dart';
import 'package:test/test.dart';

void main() {
  test('survives cache recreation and expires after ttl', () async {
    var now = DateTime(2026);
    final store = MemoryKeyValueStore();
    PersistentJsonCache create() => PersistentJsonCache(
          store: store,
          key: 'items',
          ttl: const Duration(minutes: 10),
          clock: () => now,
        );

    await create().write(const [1, 2]);
    expect(await create().read(), [1, 2]);
    now = now.add(const Duration(minutes: 10));
    expect(await create().read(), isNull);
  });
}
