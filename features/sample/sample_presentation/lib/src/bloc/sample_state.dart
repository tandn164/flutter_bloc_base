import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sample_domain/sample_domain.dart';

part 'sample_state.freezed.dart';

enum SampleNoticeKind { success, error }

class SampleNotice extends Equatable {
  const SampleNotice({
    required this.message,
    required this.kind,
    required this.id,
  });

  final String message;
  final SampleNoticeKind kind;
  final int id;

  @override
  List<Object?> get props => [message, kind, id];
}

@freezed
sealed class SampleState with _$SampleState {
  const factory SampleState.loading({SampleNotice? notice}) = SampleLoading;
  const factory SampleState.data(
    List<SampleItem> items, {
    @Default(false) bool hasMore,
    @Default(false) bool loadingMore,
    @Default(1) int page,
    @Default(0) int generation,
    SampleNotice? notice,
  }) = SampleData;
  const factory SampleState.error(String message, {SampleNotice? notice}) =
      SampleError;
}
