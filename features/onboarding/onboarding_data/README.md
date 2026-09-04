# Onboarding Data

Persists onboarding completion through the provider-independent `KeyValueStore`.

```dart
final repository = StoredOnboardingRepository(store);
await repository.complete('main-v1');
```

Use secure or database-backed storage only when the product's onboarding state
requires it. Completion state is normally not sensitive.

## Dependency injection

Annotations on classes generate `lib/di/onboarding_data_di.module.dart`.
The app selects this module explicitly; importing the package does not register
anything. Constructors remain usable directly in tests. See the
[DI guide](../../../tool/DEPENDENCY_INJECTION.md) for configuration and lifetimes.
