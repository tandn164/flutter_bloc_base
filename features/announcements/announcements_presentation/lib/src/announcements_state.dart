import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:announcements_domain/announcements_domain.dart';

part 'announcements_state.freezed.dart';

@freezed
sealed class AnnouncementsState with _$AnnouncementsState {
  const factory AnnouncementsState.loading() = AnnouncementsLoading;
  const factory AnnouncementsState.data(List<AnnouncementsItem> items) =
      AnnouncementsData;
  const factory AnnouncementsState.error(String message) = AnnouncementsError;
}
