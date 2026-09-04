# Profile Data

Chopper API, DTO mapping, and repository implementation for `profile_domain`.
The app creates the generated API service and injects its shared `DataGateway`.

```bash
dart run build_runner build --delete-conflicting-outputs
dart test features/profile/profile_data
```

Change endpoint paths in this package when they are part of the reusable profile
contract; keep demo-only backend behavior in the demo app.

## Package-owned DI

Classes use Injectable annotations and constructor injection. Generate
`lib/di/profile_data_di.module.dart` with `make codegen APP=sample_app`.
The app selects this module explicitly; importing this package does not register
anything. Direct constructor usage in existing tests remains supported.
See the [DI guide](../../../tool/DEPENDENCY_INJECTION.md) for module order,
external providers, callback factory parameters and environment selection.
