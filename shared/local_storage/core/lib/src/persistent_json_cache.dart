import 'dart:convert';

import 'key_value_store.dart';

typedef Clock = DateTime Function();

/// One disposable JSON value persisted with an expiration timestamp.
class PersistentJsonCache {
  PersistentJsonCache({
    required this.store,
    required this.key,
    required this.ttl,
    Clock? clock,
  }) : _clock = clock ?? DateTime.now;

  final KeyValueStore store;
  final String key;
  final Duration ttl;
  final Clock _clock;

  Future<Object?> read() async {
    final raw = await store.readString(key);
    if (raw == null) return null;
    try {
      final envelope = jsonDecode(raw) as Map<String, dynamic>;
      final writtenAt = DateTime.parse(envelope['writtenAt'] as String);
      if (_clock().difference(writtenAt) >= ttl) {
        await clear();
        return null;
      }
      return envelope['value'];
    } catch (_) {
      await clear();
      return null;
    }
  }

  Future<void> write(Object? value) => store.writeString(
        key,
        jsonEncode({
          'writtenAt': _clock().toIso8601String(),
          'value': value,
        }),
      );

  Future<void> clear() => store.remove(key);
}
