import 'package:injectable/injectable.dart';
import 'announcements_item.dart';
import 'announcements_repository.dart';

@lazySingleton
class ListAnnouncementsItems {
  const ListAnnouncementsItems(this.repository);

  final AnnouncementsRepository repository;

  Future<List<AnnouncementsItem>> call({bool forceRefresh = false}) =>
      repository.listItems(forceRefresh: forceRefresh);
}

@lazySingleton
class ClearAnnouncementsCache {
  const ClearAnnouncementsCache(this.repository);
  final AnnouncementsRepository repository;
  Future<void> call() => repository.clearCache();
}
