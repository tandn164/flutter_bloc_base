# Memory Cache

Use this package for small, disposable data that may be reused for a short time.
Nothing is persisted; killing the app clears every entry.

```dart
final cache = MemoryTtlCache<String, List<Item>>(
  ttl: const Duration(minutes: 10),
);

final cached = cache.read('items');
cache.write('items', items);
cache.remove('items');
```

Keep cache decisions in the feature repository. Do not add cache behavior to
the HTTP client. Use a local database and an offline-first repository when data
must remain available after process death.
