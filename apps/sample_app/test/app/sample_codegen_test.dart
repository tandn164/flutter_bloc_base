import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:sample_domain/sample_domain.dart';
import 'package:sample_data/sample_data.dart';
import 'package:sample_presentation/sample_presentation.dart';
import 'package:local_storage/local_storage.dart';
import 'package:onboarding_domain/onboarding_domain.dart';
import 'package:onboarding_data/onboarding_data.dart';
import 'package:sample_app/app/features/onboarding/onboarding_di.dart';
import 'package:sample_app/app/features/onboarding/onboarding_routes.dart';
import 'package:sample_app/app/features/showcase/showcase_routes.dart';
import 'package:sample_app/app/features/sample/sample_di.dart';
import 'package:sample_app/app/features/sample/sample_routes.dart';
import 'package:sample_app/app/router/app_router.dart';

void main() {
  test('onboarding also supports an app-selected repository', () async {
    final container = GetIt.asNewInstance();
    addTearDown(container.reset);
    final repository =
        StoredOnboardingRepository(MemoryKeyValueStore(), keyPrefix: 'custom.');
    container.registerSingleton<OnboardingRepository>(repository);
    await registerOnboardingDependencies(container, environment: 'custom');
    expect(container<OnboardingRepository>(), same(repository));
    await container<CompleteOnboarding>()('flow');
    expect(await container<ShouldShowOnboarding>()('flow'), isFalse);
    expect(container.isRegistered<KeyValueStore>(), isFalse);
    expect(container.isRegistered<SampleRepository>(), isFalse);
  });

  test('app can supply a repository without duplicate default registration',
      () async {
    final container = GetIt.asNewInstance();
    addTearDown(container.reset);
    final repository =
        LocalSampleRepository(latency: Duration.zero, initialItems: []);
    container.registerSingleton<SampleRepository>(repository);
    await registerSampleDependencies(container, environment: 'custom');
    expect(container<SampleRepository>(), same(repository));
    final result = await container<GetSample>().execute();
    result.fold(
        ok: (chunk) => expect(chunk.items, isEmpty),
        err: (error) => fail('$error'));
    expect(container.isRegistered<OnboardingRepository>(), isFalse);
  });

  test('custom environment requires an app-supplied repository', () async {
    final container = GetIt.asNewInstance();
    addTearDown(container.reset);
    await registerSampleDependencies(container, environment: 'custom');
    expect(container.isRegistered<SampleRepository>(), isFalse);
    expect(() => container<GetSample>(), throwsStateError);
  });

  test('typed routes agree with every public route and shell branch', () {
    final container = GetIt.asNewInstance();
    expect(const OnboardingRoute().location, '/onboarding');
    expect(const ShowcaseRoute().location, '/home');
    expect(const OfflineBlockRoute().location, '/offline-block');
    expect((createOnboardingRoutes(container).single as GoRoute).path,
        const OnboardingRoute().location);
    expect((createShowcaseRoutes().single as GoRoute).path,
        const OfflineBlockRoute().location);
    expect((createShowcaseBranch(container).routes.single as GoRoute).path,
        const ShowcaseRoute().location);
  });
  test('onboarding DI remains lazy and scoped to its container', () async {
    final container = GetIt.asNewInstance();
    final disabled = GetIt.asNewInstance();
    addTearDown(container.reset);
    addTearDown(disabled.reset);
    await registerOnboardingDependencies(container);
    expect(container.isRegistered<OnboardingRepository>(), isTrue);
    expect(container.isRegistered<ShouldShowOnboarding>(), isTrue);
    expect(container.isRegistered<CompleteOnboarding>(), isTrue);
    // Resolving the repository needs the app-owned store, registering does not.
    expect(container.isRegistered<KeyValueStore>(), isFalse);
    final store = MemoryKeyValueStore();
    container.registerSingleton<KeyValueStore>(store);
    final repository = container<OnboardingRepository>();
    expect(container<OnboardingRepository>(), same(repository));
    expect(container<ShouldShowOnboarding>(),
        same(container<ShouldShowOnboarding>()));
    expect(
        container<CompleteOnboarding>(), same(container<CompleteOnboarding>()));
    expect(container<ShouldShowOnboarding>().repository, same(repository));
    expect(container<CompleteOnboarding>().repository, same(repository));
    expect(await container<ShouldShowOnboarding>()('test-flow'), isTrue);
    await container<CompleteOnboarding>()('test-flow');
    expect(await container<ShouldShowOnboarding>()('test-flow'), isFalse);
    expect(disabled.isRegistered<OnboardingRepository>(), isFalse);
    expect(container.isRegistered<SampleRepository>(), isFalse);
  });
  test('direct router composition preserves public routes and tab order', () {
    final router = createRouter();
    addTearDown(router.dispose);
    final roots = router.configuration.routes;
    expect(roots.whereType<GoRoute>().map((route) => route.path),
        containsAllInOrder(['/onboarding', '/offline-block']));
    final shell = roots.whereType<StatefulShellRoute>().single;
    expect(
        shell.branches.map((branch) => (branch.routes.single as GoRoute).path),
        containsAllInOrder(['/home', '/sample']));
  });
  test('sample DI is opt-in and isolated to the supplied container', () async {
    final enabled = GetIt.asNewInstance();
    final disabled = GetIt.asNewInstance();
    addTearDown(enabled.reset);
    addTearDown(disabled.reset);
    expect(disabled.isRegistered<SampleRepository>(), isFalse);
    await registerSampleDependencies(enabled);
    expect(enabled<SampleRepository>(), same(enabled<SampleRepository>()));
    expect(enabled<GetSample>(), isA<GetSample>());
    expect(enabled<CreateSampleItem>(), isA<CreateSampleItem>());
    expect(enabled<UpdateSampleItem>(), isA<UpdateSampleItem>());
    expect(enabled<DeleteSampleItem>(), isA<DeleteSampleItem>());
    final first = enabled<SampleBloc>();
    final second = enabled<SampleBloc>();
    addTearDown(first.close);
    addTearDown(second.close);
    expect(first, isNot(same(second)));
    expect(disabled.isRegistered<SampleRepository>(), isFalse);
  });

  test('typed sample route agrees with the shell registration', () {
    final container = GetIt.asNewInstance();
    expect(const SampleRoute().location, '/sample');
    expect(createSampleBranch(container).routes, hasLength(1));
  });
}
