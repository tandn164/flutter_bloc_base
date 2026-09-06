import 'package:announcements_data/announcements_data.dart';
import 'package:test/test.dart';

void main() {
  test('DTO JSON round-trip and explicit entity mapping', () {
    const dto = AnnouncementsItemDto(id: '1', title: 'Sample');
    expect(AnnouncementsItemDto.fromJson(dto.toJson()), dto);
    expect(dto.toEntity().id, '1');
  });
}
