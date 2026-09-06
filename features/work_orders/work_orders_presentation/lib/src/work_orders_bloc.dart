import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:work_orders_domain/work_orders_domain.dart';

import 'work_orders_event.dart';
import 'work_orders_state.dart';

export 'work_orders_event.dart';
export 'work_orders_state.dart';

@injectable
class WorkOrdersBloc extends Bloc<WorkOrdersEvent, WorkOrdersState> {
  WorkOrdersBloc(
    this._listItems,
    this._synchronize,
    this._create,
    this._setCompleted,
  ) : super(const WorkOrdersLoading()) {
    on<WorkOrdersStarted>((event, emit) async {
      emit(const WorkOrdersLoading());
      try {
        await emit.forEach(
          _listItems(),
          onData: WorkOrdersData.new,
          onError: (_, __) =>
              const WorkOrdersError('Unable to read local work orders'),
        );
      } catch (_) {
        if (!emit.isDone) emit(const WorkOrdersError('Unable to load items'));
      }
    });
    on<WorkOrdersSyncRequested>((event, emit) async {
      try {
        await _synchronize();
      } catch (_) {
        if (!emit.isDone) {
          emit(const WorkOrdersError('Sync failed; local data is unchanged'));
        }
      }
    });
    on<WorkOrderCreated>((event, emit) => _create(event.title));
    on<WorkOrderToggled>(
      (event, emit) => _setCompleted(event.id, event.completed),
    );
  }

  final ListWorkOrdersItems _listItems;
  final SynchronizeWorkOrders _synchronize;
  final CreateWorkOrder _create;
  final SetWorkOrderCompleted _setCompleted;
}
