# Profile Presentation

Flutter profile page and BLoC. Supply domain use cases and app-owned callbacks
for notices, sign-out, and optional demo content.

```dart
ProfilePage(
  createBloc: () => ProfileBloc(
    getProfile: getIt(),
    updateProfile: getIt(),
    onSignOut: session.signOut,
  ),
  onNotice: showProfileNotice,
)
```

The package has no dependency on `profile_data`, GetIt, or GoRouter.

```bash
flutter test features/profile/profile_presentation
```

## Package-owned DI

Classes use Injectable annotations and constructor injection. Generate
`lib/di/profile_presentation_di.module.dart` with `make codegen APP=sample_app`.
The app selects this module explicitly; importing this package does not register
anything. Direct constructor usage in existing tests remains supported.
See the [DI guide](../../../tool/DEPENDENCY_INJECTION.md) for module order,
external providers, callback factory parameters and environment selection.
