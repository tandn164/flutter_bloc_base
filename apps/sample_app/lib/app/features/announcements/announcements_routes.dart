import 'package:announcements_presentation/announcements_presentation.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

part 'announcements_routes.g.dart';

@TypedGoRoute<AnnouncementsRoute>(path: '/announcements')
class AnnouncementsRoute extends GoRouteData {
  const AnnouncementsRoute();
  @override
  Widget build(BuildContext context, GoRouterState state) =>
      throw UnsupportedError('Mounted through the app shell');
}

StatefulShellBranch createAnnouncementsBranch(GetIt sl) => StatefulShellBranch(
      routes: [
        GoRoute(
          path: const AnnouncementsRoute().location,
          builder: (_, __) => AnnouncementsPage(
            createBloc: () => sl<AnnouncementsBloc>(),
          ),
        ),
      ],
    );
