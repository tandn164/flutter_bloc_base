# Auth Data

Authentication API and persistence implementations for `auth_domain` and the
shared `Session` contract.

## Composition

The package module creates `AuthApi`, its datasource, and the repository. The app
provides `ChopperClient`, `ApiTransport`, `TokenVault`, and `AuthSessionConfig`,
then selects this module. Bind `Session` to `AuthSession`
when the product uses this auth feature.
Use `ApiTokenRefresher` for refresh-token calls; `interceptor` (`AuthInterceptor`) coordinates
single-flight refresh and request retry.

Login and signup call generated Chopper endpoints directly. Authentication
requests are network-only by nature; they are never cached or queued.
They use the common safe-decode/error mapper without enabling unsafe automatic
credential retry.

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
external providers, callback factory parameters and explicit app bindings.
