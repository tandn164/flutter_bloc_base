import 'package:memory_cache/memory_cache.dart';
import 'package:test/test.dart';

void main() {
  test('expires entries after ttl', () {
    var now = DateTime(2026);
    final cache = MemoryTtlCache<String, int>(
      ttl: const Duration(minutes: 5),
      clock: () => now,
    );
    cache.write('answer', 42);
    expect(cache.read('answer'), 42);
    now = now.add(const Duration(minutes: 5));
    expect(cache.read('answer'), isNull);
  });
}
