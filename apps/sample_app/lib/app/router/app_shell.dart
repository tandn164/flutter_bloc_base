import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ui_kit/ui_kit.dart';

class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    const destinations = [
      AdaptiveDestination(
        icon: Icon(Icons.check_box_outlined),
        label: 'Capabilities',
      ),
      AdaptiveDestination(
        icon: Icon(Icons.home_repair_service_outlined),
        label: 'Catalog',
      ),
      AdaptiveDestination(
        icon: Icon(Icons.campaign_outlined),
        label: 'News',
      ),
      AdaptiveDestination(
        icon: Icon(Icons.assignment_outlined),
        label: 'Work',
      ),
    ];

    return AdaptiveNavigationShell(
      destinations: destinations,
      selectedIndex: navigationShell.currentIndex,
      onSelected: navigationShell.goBranch,
      body: navigationShell,
    );
  }
}
