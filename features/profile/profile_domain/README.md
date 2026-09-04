# Profile Domain

Pure Dart profile entity, repository contract, and use cases.

```dart
final result = await GetProfile(repository).execute();
final updated = await UpdateProfile(repository).execute(name: 'Taylor');
```

Keep API payloads, local storage, widgets, and routing outside this package.

```bash
dart test features/profile/profile_domain
```

## Package-owned DI

Classes use Injectable annotations and constructor injection. Generate
`lib/di/profile_domain_di.module.dart` with `make codegen APP=sample_app`.
The app selects this module explicitly; importing this package does not register
anything. Direct constructor usage in existing tests remains supported.
See the [DI guide](../../../tool/DEPENDENCY_INJECTION.md) for module order,
external providers, callback factory parameters and environment selection.
