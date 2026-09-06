import 'package:freezed_annotation/freezed_annotation.dart';

part 'announcements_item.freezed.dart';

@freezed
abstract class AnnouncementsItem with _$AnnouncementsItem {
  const factory AnnouncementsItem({required String id, required String title}) =
      _AnnouncementsItem;
}
