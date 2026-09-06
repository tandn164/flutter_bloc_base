sealed class WorkOrdersEvent {
  const WorkOrdersEvent();
}

class WorkOrdersStarted extends WorkOrdersEvent {
  const WorkOrdersStarted();
}

class WorkOrdersSyncRequested extends WorkOrdersEvent {
  const WorkOrdersSyncRequested();
}

class WorkOrderCreated extends WorkOrdersEvent {
  const WorkOrderCreated(this.title);
  final String title;
}

class WorkOrderToggled extends WorkOrdersEvent {
  const WorkOrderToggled(this.id, this.completed);
  final String id;
  final bool completed;
}
