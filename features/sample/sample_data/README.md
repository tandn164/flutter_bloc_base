# Sample Data

Chopper API, DTO mapping, and `SampleRepositoryImpl` for `sample_domain`.

`SampleItemDto` uses Freezed + json_serializable. Run `make codegen` after field
changes; generated `fromJson`/`toJson` do not replace API-boundary `safeDecode`.
DTO-to-entity mapping stays explicit in `toEntity()`.

`LocalSampleRepository` is the self-contained implementation used only to make
the sample feature runnable. It performs pagination and mutations directly and
does not pretend to be an HTTP server.

The app injects `SampleApi`, `DataGateway`, and an operation-ID factory. Mutation
requests use stable idempotency keys when offline retry is enabled, so the server
must deduplicate repeated keys.

```bash
dart run build_runner build --delete-conflicting-outputs
dart test features/sample/sample_data
```

## Dependency injection

Annotations on classes generate `lib/di/sample_data_di.module.dart`.
The app selects this module explicitly; importing the package does not register
anything. Constructors remain usable directly in tests. See the
[DI guide](../../../tool/DEPENDENCY_INJECTION.md) for configuration and lifetimes.
