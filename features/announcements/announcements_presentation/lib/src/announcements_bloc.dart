import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:announcements_domain/announcements_domain.dart';

import 'announcements_event.dart';
import 'announcements_state.dart';

export 'announcements_event.dart';
export 'announcements_state.dart';

@injectable
class AnnouncementsBloc extends Bloc<AnnouncementsEvent, AnnouncementsState> {
  AnnouncementsBloc(this._listItems, this._clearCache)
      : super(const AnnouncementsLoading()) {
    on<AnnouncementsStarted>((event, emit) async {
      await _load(emit);
    });
    on<AnnouncementsRefreshRequested>((event, emit) async {
      await _load(emit, forceRefresh: true);
    });
    on<AnnouncementsCacheClearRequested>((event, emit) async {
      await _clearCache();
      emit(const AnnouncementsData([]));
    });
  }

  Future<void> _load(
    Emitter<AnnouncementsState> emit, {
    bool forceRefresh = false,
  }) async {
    emit(const AnnouncementsLoading());
    try {
      final items = await _listItems(forceRefresh: forceRefresh);
      if (!emit.isDone) emit(AnnouncementsData(items));
    } catch (_) {
      if (!emit.isDone) {
        emit(const AnnouncementsError('Unable to load items'));
      }
    }
  }

  final ListAnnouncementsItems _listItems;
  final ClearAnnouncementsCache _clearCache;
}
