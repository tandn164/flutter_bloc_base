# Auth Presentation

Flutter pages and BLoCs for login, signup, and forgotten-password flows.

## Usage

The app creates the BLoC and passes app-owned behavior into the page:

```dart
LoginPage(
  createBloc: () => LoginBloc(
    login: getIt(),
    onAuthenticated: saveSession,
  ),
  onSignup: openSignup,
  onForgotPassword: openForgotPassword,
  onNotice: showAuthNotice,
)
```

The package does not use GetIt, import `auth_data`, own route strings, or own
brand copy. Keep navigation and overlay decisions in the app adapter.

## Testing

```bash
flutter test features/auth/auth_presentation
```

## Package-owned DI

Classes use Injectable annotations and constructor injection. Generate
`lib/di/auth_presentation_di.module.dart` with `make codegen APP=sample_app`.
The app selects this module explicitly; importing this package does not register
anything. Direct constructor usage in existing tests remains supported.
See the [DI guide](../../../tool/DEPENDENCY_INJECTION.md) for module order,
external providers, callback factory parameters and environment selection.
