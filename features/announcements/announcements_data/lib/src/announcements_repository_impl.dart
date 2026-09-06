import 'package:injectable/injectable.dart';
import 'package:announcements_domain/announcements_domain.dart';
import 'package:memory_cache/memory_cache.dart';

import 'announcements_remote_data_source.dart';

@LazySingleton(as: AnnouncementsRepository)
class AnnouncementsRepositoryImpl implements AnnouncementsRepository {
  AnnouncementsRepositoryImpl(
    this._remote, {
    Duration ttl = const Duration(minutes: 10),
  }) : _cache = MemoryTtlCache(ttl: ttl);

  @factoryMethod
  static AnnouncementsRepositoryImpl create(
    AnnouncementsRemoteDataSource remote,
  ) =>
      AnnouncementsRepositoryImpl(remote);

  final AnnouncementsRemoteDataSource _remote;
  static const _cacheKey = 'announcements';
  final MemoryTtlCache<String, List<AnnouncementsItem>> _cache;

  @override
  Future<List<AnnouncementsItem>> listItems({bool forceRefresh = false}) async {
    if (!forceRefresh) {
      final cached = _cache.read(_cacheKey);
      if (cached != null) return cached;
    }
    final remote = await _remote.fetchAnnouncements();
    final items = List<AnnouncementsItem>.unmodifiable(
      remote.map((item) => item.toEntity()),
    );
    _cache.write(_cacheKey, items);
    return items;
  }

  @override
  Future<void> clearCache() async => _cache.clear();
}
