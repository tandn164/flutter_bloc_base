# Package-owned dependency injection

Feature packages register concrete classes. The app composition root selects
which concrete implementation satisfies each domain contract. Injectable
environments are not used as repository or datasource switches.

## Package rule

Annotate concrete dependencies beside their classes:

```dart
@LazySingleton()
class ProfileRepositoryImpl implements ProfileRepository { ... }
```

Use `@injectable` for a new instance and `@lazySingleton`/`@LazySingleton()` for
one lazily created instance. Domain entities, DTOs, repository interfaces, and
plain widgets need no annotation. Business and UI classes use constructor
injection; never call `GetIt.instance` from them.

Each dependency-owning package has `lib/di/<package>_di.dart` with
`@InjectableInit.microPackage()`. Its generated `.module.dart` registers package
internals. `ignoreUnregisteredTypes` contains only contracts supplied by the app
or another selected module.

## App selection

App feature DI initializes selected package modules and then binds the domain
interface explicitly:

```dart
await container.initSampleFeature();
container.registerLazySingleton<SampleRepository>(
  () => switch (source) {
    SampleRepositorySource.local => container<LocalSampleRepository>(),
    SampleRepositorySource.rest => container<SampleRepositoryImpl>(),
  },
);
```

The default sample app call is explicit and type-safe:

```dart
await registerSampleDependencies(
  container,
  source: SampleRepositorySource.local,
);
```

To supply an app-specific implementation, register the contract first. The
feature initializer preserves an existing binding:

```dart
container.registerSingleton<SampleRepository>(myRepository);
await registerSampleDependencies(container);
```

No `remote`, `local`, or `custom` Injectable environment string is involved.
Build flavors such as development/staging/production configure URLs, Firebase,
logging, and credentials; they do not decide repository architecture.

## External providers

- REST implementations require an app-configured `ChopperClient`.
- Auth additionally requires `ApiTransport`, `TokenVault`,
  `AuthSessionConfig`, and a binding from `TokenRefresher` to the selected
  implementation such as `ApiTokenRefresher`.
- Onboarding's stored implementation requires `KeyValueStore`.
- Firestore, Realtime Database, and local-database implementations require their
  provider clients from app bootstrap.

Auth/Profile package modules expose concrete implementations; an app integrating
them must bind `AuthRepository`, `ProfileRepository`, `TokenRefresher`, and
`Session` deliberately. This prevents importing a package from silently choosing
the product's authentication or storage policy.

## Generation and verification

```bash
make codegen APP=sample_app
make lint APP=sample_app
make test APP=sample_app
```

Never hand-edit `.module.dart` or `.config.dart`. BLoCs remain factories and are
owned/disposed by their pages. Use Injectable environments only when a dependency
truly differs by runtime deployment environment; do not use them for datasource
selection.
