# Sample App

This Flutter application demonstrates how a product composes reusable feature
and shared packages. It is intentionally a thin composition root, not a source
of reusable business or infrastructure code.

## What remains app-owned

- bootstrap, flavors, theme, and native projects;
- GetIt registrations in `lib/app/di.dart`;
- GoRouter route names and tab order;
- product copy and callbacks passed into feature presentation packages;
- the capability showcase UI that triggers reusable base behavior.

Reusable behavior must be added to `features/`, `shared/`, or a real
`integrations/` package first, then consumed here.

## Run

```bash
make run APP=sample_app FLAVOR=dev
```

The **Capabilities** tab triggers shared UI and infrastructure. Three Field
Operations features demonstrate distinct data strategies:

- **Service catalog:** remote-only; every load calls the provider.
- **Announcements:** remote datasource with a configurable 10-minute memory cache.
- **Work orders:** Drift-backed local source of truth, optimistic writes and synchronization.

`FieldOperationsSampleApi` is an app-owned, in-process backend simulator. It is
registered against datasource contracts in `app/di.dart`; feature packages do
not know about it. Product apps replace these registrations with Chopper,
Firestore or another provider adapter.

## Feature selection

Select feature dependency initializers in `lib/app/di.dart` and routes/tab
branches in `lib/app/router/app_router.dart`. There is no separate feature
manifest. Keep tab destinations in `app_shell.dart` aligned with branch order.
Each feature has one folder under `lib/app/features/<name>/`:

- `<name>_di.dart`: dependency registration only; imported by app `di.dart`.
- `<name>_routes.dart`: routes, page builders and callbacks; imported by `app_router.dart`.
- Generated `.config.dart` / `.g.dart` files live beside the source that owns them.

See [feature wiring](lib/app/features/README.md) for the current layout and usage.
Real providers belong in app composition or an `integrations/` adapter.

## Firebase configuration

Per-flavor Android and iOS configuration folders are already prepared. See
[FIREBASE.md](FIREBASE.md) before adding Firebase SDKs or release credentials.

## Validate

```bash
make codegen APP=sample_app
make lint APP=sample_app
make test APP=sample_app
```
