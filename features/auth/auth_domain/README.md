# Auth Domain

Pure Dart authentication business contracts.

## Usage

```dart
final login = LoginUseCase(authRepository);
final result = await login.execute(email: email, password: password);
```

Implement `AuthRepository` in a data package. Keep HTTP, token persistence,
Flutter widgets, routing, and service locators outside this package.

## Testing

```bash
dart test features/auth/auth_domain
```

## Package-owned DI

Classes use Injectable annotations and constructor injection. Generate
`lib/di/auth_domain_di.module.dart` with `make codegen APP=sample_app`.
The app selects this module explicitly; importing this package does not register
anything. Direct constructor usage in existing tests remains supported.
See the [DI guide](../../../tool/DEPENDENCY_INJECTION.md) for module order,
external providers, callback factory parameters and environment selection.
