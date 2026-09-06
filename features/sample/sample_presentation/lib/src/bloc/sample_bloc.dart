import 'package:injectable/injectable.dart';
import 'package:sample_domain/sample_domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'sample_event.dart';
import 'sample_state.dart';

export 'sample_event.dart';
export 'sample_state.dart';

@injectable
class SampleBloc extends Bloc<SampleEvent, SampleState> {
  SampleBloc({
    required GetSample getSample,
    required CreateSampleItem createItem,
    required UpdateSampleItem updateItem,
    required DeleteSampleItem deleteItem,
  })  : _getSample = getSample,
        _createItem = createItem,
        _updateItem = updateItem,
        _deleteItem = deleteItem,
        super(const SampleLoading()) {
    on<SampleStarted>(_load);
    on<SampleRefreshed>(_refresh);
    on<SampleLoadMore>(_loadMore);
    on<SampleCreated>(_create);
    on<SampleToggled>(_toggle);
    on<SampleRenamed>(_rename);
    on<SampleDeleted>(_delete);
  }

  final GetSample _getSample;
  final CreateSampleItem _createItem;
  final UpdateSampleItem _updateItem;
  final DeleteSampleItem _deleteItem;
  int _generation = 0;
  int _noticeId = 0;

  SampleNotice _notice(String message, SampleNoticeKind kind) {
    return SampleNotice(message: message, kind: kind, id: ++_noticeId);
  }

  Future<void> _load(SampleStarted event, Emitter<SampleState> emit) async {
    emit(const SampleLoading());
    final result = await _getSample.execute();
    result.fold(
      ok: (chunk) => emit(SampleData(
        chunk.items,
        hasMore: chunk.hasMore,
        page: 1,
        generation: ++_generation,
      )),
      err: (f) => emit(SampleError(
        f.message,
        notice: _notice(f.message, SampleNoticeKind.error),
      )),
    );
  }

  Future<void> _refresh(
      SampleRefreshed event, Emitter<SampleState> emit) async {
    final result = await _getSample.execute(forceNetwork: true);
    result.fold(
      ok: (chunk) => emit(SampleData(
        chunk.items,
        hasMore: chunk.hasMore,
        page: 1,
        generation: ++_generation,
      )),
      err: (f) {
        final current = state;
        if (current is SampleData) {
          emit(current.copyWith(
              notice: _notice(f.message, SampleNoticeKind.error)));
        } else {
          emit(SampleError(f.message,
              notice: _notice(f.message, SampleNoticeKind.error)));
        }
      },
    );
  }

  Future<void> _loadMore(
      SampleLoadMore event, Emitter<SampleState> emit) async {
    final current = state;
    if (current is! SampleData || !current.hasMore || current.loadingMore) {
      return;
    }
    emit(current.copyWith(loadingMore: true, notice: null));
    final page = current.page + 1;
    final result = await _getSample.execute(page: page);
    if (emit.isDone) return;
    result.fold(
      ok: (chunk) {
        final seen = {for (final e in current.items) e.id};
        emit(SampleData(
          [
            ...current.items,
            for (final e in chunk.items)
              if (seen.add(e.id)) e
          ],
          hasMore: chunk.hasMore,
          page: page,
          generation: ++_generation,
        ));
      },
      err: (f) {
        emit(current.copyWith(
          loadingMore: false,
          notice: _notice(f.message, SampleNoticeKind.error),
        ));
      },
    );
  }

  Future<void> _create(SampleCreated event, Emitter<SampleState> emit) async {
    final result = await _createItem.execute(title: event.title);
    if (emit.isDone) return;
    result.fold(
      ok: (item) {
        final current = state;
        if (current is SampleData) {
          final without = [
            for (final e in current.items)
              if (e.id != item.id) e
          ];
          emit(current.copyWith(
            items: [item, ...without],
            generation: ++_generation,
            notice: _notice('Task added', SampleNoticeKind.success),
          ));
        } else {
          emit(SampleLoading(
              notice: _notice('Task added', SampleNoticeKind.success)));
          add(const SampleRefreshed());
        }
      },
      err: (f) {
        final current = state;
        if (current is SampleData) {
          emit(current.copyWith(
              notice: _notice(f.message, SampleNoticeKind.error)));
        }
      },
    );
  }

  Future<void> _toggle(SampleToggled event, Emitter<SampleState> emit) async {
    final current = state;
    if (current is! SampleData) return;
    final index = current.items.indexWhere((e) => e.id == event.id);
    if (index < 0) return;
    final previous = current.items[index];
    final next = previous.copyWith(done: !previous.done);
    emit(current.copyWith(
      items: [...current.items]..[index] = next,
      generation: ++_generation,
      notice: null,
    ));
    final result = await _updateItem.execute(id: event.id, done: next.done);
    if (emit.isDone) return;
    result.fold(
      ok: (item) {
        final latest = state;
        if (latest is! SampleData) return;
        final i = latest.items.indexWhere((e) => e.id == item.id);
        if (i < 0) return;
        emit(latest.copyWith(
          items: [...latest.items]..[i] = item,
          generation: ++_generation,
          notice: null,
        ));
      },
      err: (f) {
        final latest = state;
        if (latest is SampleData) {
          final i = latest.items.indexWhere((e) => e.id == event.id);
          if (i >= 0) {
            emit(latest.copyWith(
              items: [...latest.items]..[i] = previous,
              generation: ++_generation,
              notice: _notice(f.message, SampleNoticeKind.error),
            ));
            return;
          }
        }
      },
    );
  }

  Future<void> _rename(SampleRenamed event, Emitter<SampleState> emit) async {
    final result = await _updateItem.execute(id: event.id, title: event.title);
    if (emit.isDone) return;
    result.fold(
      ok: (item) {
        final current = state;
        if (current is! SampleData) return;
        final i = current.items.indexWhere((e) => e.id == item.id);
        if (i < 0) return;
        emit(current.copyWith(
          items: [...current.items]..[i] = item,
          generation: ++_generation,
          notice: _notice('Task updated', SampleNoticeKind.success),
        ));
      },
      err: (f) {
        final current = state;
        if (current is SampleData) {
          emit(current.copyWith(
              notice: _notice(f.message, SampleNoticeKind.error)));
        }
      },
    );
  }

  Future<void> _delete(SampleDeleted event, Emitter<SampleState> emit) async {
    final current = state;
    if (current is! SampleData) return;
    final remaining = [
      for (final e in current.items)
        if (e.id != event.id) e
    ];
    emit(current.copyWith(
        items: remaining, generation: ++_generation, notice: null));
    final result = await _deleteItem.execute(id: event.id);
    if (emit.isDone) return;
    result.fold(
      ok: (_) {},
      err: (f) {
        emit(current.copyWith(
            notice: _notice(f.message, SampleNoticeKind.error)));
        add(const SampleRefreshed());
      },
    );
  }
}
