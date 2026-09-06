import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'work_orders_bloc.dart';

class WorkOrdersPage extends StatelessWidget {
  const WorkOrdersPage(
      {super.key, required this.createBloc, this.title = 'Work orders'});
  final WorkOrdersBloc Function() createBloc;
  final String title;

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (_) => createBloc()..add(const WorkOrdersStarted()),
        child: Builder(
            builder: (context) => Scaffold(
                  appBar: AppBar(
                    title: Text(title),
                    bottom: const PreferredSize(
                      preferredSize: Size.fromHeight(28),
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 8),
                        child: Text(
                            'Local source of truth · offline writes · synchronization'),
                      ),
                    ),
                    actions: [
                      IconButton(
                        tooltip: 'Synchronize',
                        onPressed: () => context
                            .read<WorkOrdersBloc>()
                            .add(const WorkOrdersSyncRequested()),
                        icon: const Icon(Icons.sync),
                      ),
                    ],
                  ),
                  floatingActionButton: FloatingActionButton(
                    onPressed: () => _createOrder(context),
                    child: const Icon(Icons.add),
                  ),
                  body: BlocBuilder<WorkOrdersBloc, WorkOrdersState>(
                    builder: (context, state) => switch (state) {
                      WorkOrdersLoading() =>
                        const Center(child: CircularProgressIndicator()),
                      WorkOrdersError(:final message) =>
                        Center(child: Text(message)),
                      WorkOrdersData(:final items) => items.isEmpty
                          ? const Center(child: Text('No items'))
                          : ListView(children: [
                              for (final item in items)
                                CheckboxListTile(
                                  value: item.completed,
                                  title: Text(item.title),
                                  subtitle: item.pendingSync
                                      ? const Text('Pending synchronization')
                                      : const Text('Synced'),
                                  onChanged: (value) =>
                                      context.read<WorkOrdersBloc>().add(
                                            WorkOrderToggled(
                                                item.id, value ?? false),
                                          ),
                                ),
                            ]),
                    },
                  ),
                )),
      );
}

Future<void> _createOrder(BuildContext context) async {
  final controller = TextEditingController();
  final title = await showDialog<String>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: const Text('New work order'),
      content: TextField(controller: controller, autofocus: true),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(dialogContext, controller.text.trim()),
          child: const Text('Save locally'),
        ),
      ],
    ),
  );
  controller.dispose();
  if (context.mounted && title != null && title.isNotEmpty) {
    context.read<WorkOrdersBloc>().add(WorkOrderCreated(title));
  }
}
