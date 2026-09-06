import 'package:announcements_data/announcements_data.dart';
import 'package:test/test.dart';

class _Remote implements AnnouncementsRemoteDataSource {
  var calls = 0;
  @override
  Future<List<AnnouncementsItemDto>> fetchAnnouncements() async {
    calls++;
    return const [AnnouncementsItemDto(id: '1', title: 'Safety update')];
  }
}

void main() {
  test('reuses memory result inside the same repository', () async {
    final remote = _Remote();
    final repository = AnnouncementsRepositoryImpl(remote);
    expect(
      (await repository.listItems()).single.title,
      'Safety update',
    );
    expect(
      (await repository.listItems()).single.title,
      'Safety update',
    );
    expect(remote.calls, 1);
  });

  test('force refresh bypasses memory cache', () async {
    final remote = _Remote();
    final repository = AnnouncementsRepositoryImpl(remote);
    await repository.listItems();
    await repository.listItems(forceRefresh: true);
    expect(remote.calls, 2);
  });
}
