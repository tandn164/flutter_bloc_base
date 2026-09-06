import 'package:announcements_domain/announcements_domain.dart';
import 'package:test/test.dart';

class _Repository implements AnnouncementsRepository {
  @override
  Future<List<AnnouncementsItem>> listItems(
          {bool forceRefresh = false}) async =>
      const [AnnouncementsItem(id: '1', title: 'Sample')];
  @override
  Future<void> clearCache() async {}
}

void main() {
  test('use case delegates; generated equality and copyWith work', () async {
    final items = await ListAnnouncementsItems(_Repository())();
    expect(items.single.copyWith(title: 'Changed'),
        const AnnouncementsItem(id: '1', title: 'Changed'));
  });
}
