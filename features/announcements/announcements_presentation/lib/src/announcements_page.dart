import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'announcements_bloc.dart';

class AnnouncementsPage extends StatelessWidget {
  const AnnouncementsPage(
      {super.key, required this.createBloc, this.title = 'Announcements'});
  final AnnouncementsBloc Function() createBloc;
  final String title;

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (_) => createBloc()..add(const AnnouncementsStarted()),
        child: Builder(
          builder: (context) => Scaffold(
            appBar: AppBar(
              title: Text(title),
              bottom: const PreferredSize(
                preferredSize: Size.fromHeight(28),
                child: Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: Text('Remote data · persistent cache (100 / 30 days)'),
                ),
              ),
              actions: [
                IconButton(
                  tooltip: 'Clear persistent cache',
                  onPressed: () => context
                      .read<AnnouncementsBloc>()
                      .add(const AnnouncementsCacheClearRequested()),
                  icon: const Icon(Icons.delete_sweep_outlined),
                ),
                IconButton(
                  tooltip: 'Refresh from remote',
                  onPressed: () => context
                      .read<AnnouncementsBloc>()
                      .add(const AnnouncementsRefreshRequested()),
                  icon: const Icon(Icons.refresh),
                ),
              ],
            ),
            body: BlocBuilder<AnnouncementsBloc, AnnouncementsState>(
              builder: (context, state) => switch (state) {
                AnnouncementsLoading() =>
                  const Center(child: CircularProgressIndicator()),
                AnnouncementsError(:final message) =>
                  Center(child: Text(message)),
                AnnouncementsData(:final items) => items.isEmpty
                    ? const Center(child: Text('No items'))
                    : ListView(children: [
                        for (final item in items)
                          ListTile(title: Text(item.title))
                      ]),
              },
            ),
          ),
        ),
      );
}
