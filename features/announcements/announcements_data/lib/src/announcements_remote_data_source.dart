import 'announcements_item_dto.dart';

abstract interface class AnnouncementsRemoteDataSource {
  Future<List<AnnouncementsItemDto>> fetchAnnouncements();
}
