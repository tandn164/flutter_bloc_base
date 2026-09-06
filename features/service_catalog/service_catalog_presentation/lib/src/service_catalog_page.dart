import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'service_catalog_bloc.dart';

class ServiceCatalogPage extends StatelessWidget {
  const ServiceCatalogPage(
      {super.key, required this.createBloc, this.title = 'Service catalog'});
  final ServiceCatalogBloc Function() createBloc;
  final String title;

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (_) => createBloc()..add(const ServiceCatalogStarted()),
        child: Builder(
          builder: (context) => Scaffold(
            appBar: AppBar(
              title: Text(title),
              bottom: const PreferredSize(
                preferredSize: Size.fromHeight(28),
                child: Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child:
                      Text('Remote data · memory cache · cleared on restart'),
                ),
              ),
              actions: [
                IconButton(
                  tooltip: 'Bypass memory cache',
                  onPressed: () => context
                      .read<ServiceCatalogBloc>()
                      .add(const ServiceCatalogRefreshRequested()),
                  icon: const Icon(Icons.refresh),
                ),
              ],
            ),
            body: BlocBuilder<ServiceCatalogBloc, ServiceCatalogState>(
              builder: (context, state) => switch (state) {
                ServiceCatalogLoading() =>
                  const Center(child: CircularProgressIndicator()),
                ServiceCatalogError(:final message) =>
                  Center(child: Text(message)),
                ServiceCatalogData(:final items) => items.isEmpty
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
