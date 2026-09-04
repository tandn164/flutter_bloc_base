# Auth Data

Authentication API and persistence implementations for `auth_domain` and the
shared `Session` contract.

## Composition

Create `AuthApi`, a `TokenVault`, and `AuthRepositoryImpl` in the app composition
root. Bind `Session` to `AuthSession` when the product uses this auth feature.
Use `ApiTokenRefresher` for refresh-token calls; `interceptor` (`AuthInterceptor`) coordinates
single-flight refresh and request retry.

`TokenVault` is an interface. Production apps should provide encrypted platform
storage for tokens; do not store credentials in plain SharedPreferences.

## Code generation

```bash
dart run build_runner build --delete-conflicting-outputs
```

## Testing

```bash
flutter test features/auth/auth_data
```

## Package-owned DI

Classes use Injectable annotations and constructor injection. Generate
`lib/di/auth_data_di.module.dart` with `make codegen APP=sample_app`.
The app selects this module explicitly; importing this package does not register
anything. Direct constructor usage in existing tests remains supported.
See the [DI guide](../../../tool/DEPENDENCY_INJECTION.md) for module order,
external providers, callback factory parameters and environment selection.
