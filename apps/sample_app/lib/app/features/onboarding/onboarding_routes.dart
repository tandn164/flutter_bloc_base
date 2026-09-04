import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:onboarding_domain/onboarding_domain.dart';
import 'package:onboarding_presentation/onboarding_presentation.dart';

import '../../di.dart' as app_di;
import '../showcase/showcase_routes.dart';

part 'onboarding_routes.g.dart';

@TypedGoRoute<OnboardingRoute>(path: '/onboarding')
class OnboardingRoute extends GoRouteData {
  const OnboardingRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      _page(context, app_di.sl);
}

const sampleOnboardingFlowId = 'sample-main-v1';

List<RouteBase> createOnboardingRoutes(GetIt sl) {
  return [
    GoRoute(
      path: const OnboardingRoute().location,
      builder: (context, _) => _page(context, sl),
    ),
  ];
}

Widget _page(BuildContext context, GetIt sl) => OnboardingPage(
      steps: [
        OnboardingStep(
          title: 'Reusable capabilities',
          description: 'The sample app composes features from the base.',
          illustration: (_) => const Icon(Icons.extension, size: 96),
        ),
        OnboardingStep(
          title: 'Offline-ready UX',
          description: 'Safe writes can be queued and synchronized later.',
          illustration: (_) => const Icon(Icons.cloud_sync, size: 96),
        ),
      ],
      onComplete: () async {
        await sl<CompleteOnboarding>()(sampleOnboardingFlowId);
        if (context.mounted) const ShowcaseRoute().go(context);
      },
      onSkip: () => const ShowcaseRoute().go(context),
    );
