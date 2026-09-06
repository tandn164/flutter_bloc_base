import 'announcements_item.dart';

abstract class AnnouncementsRepository {
  Future<List<AnnouncementsItem>> listItems({bool forceRefresh = false});

  Future<void> clearCache();
}
