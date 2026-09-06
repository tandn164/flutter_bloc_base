typedef Clock = DateTime Function();

/// A process-local cache. Entries disappear when the app process is killed.
class MemoryTtlCache<K, V> {
  MemoryTtlCache({
    required this.ttl,
    Clock? clock,
  }) : _clock = clock ?? DateTime.now;

  final Duration ttl;
  final Clock _clock;
  final Map<K, _Entry<V>> _entries = {};

  V? read(K key) {
    final entry = _entries[key];
    if (entry == null) return null;
    if (_clock().difference(entry.writtenAt) >= ttl) {
      _entries.remove(key);
      return null;
    }
    return entry.value;
  }

  void write(K key, V value) {
    _entries[key] = _Entry(value, _clock());
  }

  void remove(K key) => _entries.remove(key);

  void clear() => _entries.clear();
}

class _Entry<V> {
  const _Entry(this.value, this.writtenAt);
  final V value;
  final DateTime writtenAt;
}
