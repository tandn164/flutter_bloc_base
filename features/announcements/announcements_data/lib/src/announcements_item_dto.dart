import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:announcements_domain/announcements_domain.dart';

part 'announcements_item_dto.freezed.dart';
part 'announcements_item_dto.g.dart';

@freezed
abstract class AnnouncementsItemDto with _$AnnouncementsItemDto {
  const AnnouncementsItemDto._();
  const factory AnnouncementsItemDto(
      {required String id, required String title}) = _AnnouncementsItemDto;
  factory AnnouncementsItemDto.fromJson(Map<String, dynamic> json) =>
      _$AnnouncementsItemDtoFromJson(json);
  AnnouncementsItem toEntity() => AnnouncementsItem(id: id, title: title);
}
