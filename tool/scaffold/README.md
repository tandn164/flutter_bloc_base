# Scaffolding

Generate a new feature package set or clone an app skeleton.

New features include Freezed models/state, generated JSON, feature-local
package-owned Injectable micro-modules, typed route helpers, an injected BLoC page and tests.
Generated presentation code keeps BLoC, event, and state declarations in three
separate files; Freezed output is generated beside the state file.
See [Code generation](../CODE_GENERATION.md) for the workflow and version contract.

Data modules register concrete implementations. App DI binds each domain
repository contract explicitly; datasource selection never depends on an
Injectable environment string.

## New feature

Creates `features/<name>/{domain,data,presentation}`, registers workspace
packages, and creates `apps/<app>/lib/app/features/<name>/` with separate
`<name>_di.dart` and `<name>_routes.dart` files. Injectable `.config.dart` and
typed-route `.g.dart` companions are generated beside their source files.
Each package also generates a `lib/di/<package>_di.module.dart`. App DI selects
these modules, awaits initialization, and owns the interface-to-implementation
binding.
See [Dependency injection](../DEPENDENCY_INJECTION.md).

```bash
make new-feature NAME=orders
make new-feature NAME=orders APP=sample_app
make new-feature NAME=catalog ROUTE_KIND=tab
make new-feature NAME=news DATA=memory-cache
make new-feature NAME=feed DATA=persistent-cache
make new-feature NAME=tasks DATA=offline-first
make new-feature NAME=drafts DATA=local
WIRE=0 make new-feature NAME=reports   # packages only
```

Defaults:

- `APP=sample_app`
- `ROUTE_KIND=public` (`public` adds a GoRoute; `tab` adds a shell branch)
- `WIRE=1` (set `WIRE=0` to skip app pubspec, `di.dart` and `app_router.dart` wiring)
- `DATA=remote`; alternatives are `memory-cache`, `persistent-cache`,
  `offline-first`, and `local`

Data strategies:

- `remote`: repository calls a generated remote datasource contract directly.
- `memory-cache`: remote datasource plus `MemoryTtlCache` with a 10-minute default TTL.
- `persistent-cache`: remote datasource plus disk cache with a 30-minute default
  TTL; cache survives app restarts but remains disposable.
- `offline-first`: Drift-backed `KeyValueStore` local datasource plus remote datasource; remote
  refresh replaces local data and local data is returned when refresh fails.
- `local`: `KeyValueStore` local datasource only; no remote contract is generated.

For strategies containing `remote`, register a real implementation of the
generated `<Feature>RemoteDataSource` in app DI before resolving the repository.
The generator never registers a fake provider.

The scaffold inserts direct calls into `di.dart` and `app_router.dart`, without
a separate feature manifest. Keep the `// scaffold:feature-*` insertion markers
in those files if you want automatic wiring. Missing markers fail before feature
creation; use `WIRE=0` to wire a custom app manually. A new tab still needs its
label/icon added to `app_shell.dart` in the same order as the router branches.

After scaffolding:

Creation runs workspace `pub get`, then codegen only for the new Domain, Data
and Presentation packages (in that order), followed by localization and codegen
for the selected app. `WIRE=0` generates only the three packages; it does not
regenerate any app. Existing features and shared packages are not regenerated.
Run `make codegen APP=sample_app` separately when full-workspace generation is
needed (for example, after editing another package's DI or missing generated files).
The selected app's build_runner may still process other libraries inside that app.

```bash
make get
make lint APP=sample_app
make test APP=sample_app
```

## Delete feature

Removes `features/<name>`, unregisters workspace packages, and unwires the app
adapter, `di.dart` and `app_router.dart`. Built-in reusable/sample features (`auth`, `sample`, `profile`,
`onboarding`) are protected.

```bash
CONFIRM=1 make delete-feature NAME=orders
CONFIRM=1 make delete-feature NAME=orders APP=sample_app
CONFIRM=1 WIRE=0 make delete-feature NAME=reports   # packages only
```

Defaults:

- `APP=sample_app`
- `WIRE=1` (set `WIRE=0` to delete packages only and keep app wiring)

## New app

Clones `apps/sample_app` (or `SOURCE=`) into a new workspace app.

```bash
make new-app NAME=merchant_app
make new-app NAME=merchant_app SOURCE=sample_app
```

`make new-app` also registers an Android Studio / IntelliJ run configuration for the
new app. If the run dropdown still shows only `sample_app`, restart the IDE or run:

```bash
bash tool/scaffold/register_ide_app.sh merchant_app
```

It also creates empty `dev`, `stg`, and `prod` Firebase configuration folders
for Android and iOS plus an ignored `.secrets` directory. Firebase client files
and credentials from the source app are deliberately excluded from the copy.

Then select dependencies in `di.dart`, routes/branches in `app_router.dart`,
align destinations in `app_shell.dart`, and update native bundle identifiers.

## Delete app

Removes `apps/<name>`, unregisters the Dart workspace entry, and cleans IDE run
configuration / module entries. `sample_app` is protected by default. After a
product app exists, remove the reference app with an explicit override:

```bash
CONFIRM=1 make delete-app NAME=merchant_app

# Only after another app exists:
CONFIRM=1 ALLOW_DELETE_SAMPLE=1 make delete-app NAME=sample_app
```

The command refuses to remove the last app in the workspace. When the deleted
app was the Makefile default, the remaining app becomes the new default.

## New shared package

```bash
make new-shared NAME=my_service                 # TYPE=dart by default
make new-shared NAME=my_widget TYPE=flutter
```

Creates a direct package at `shared/<name>` with a public barrel, `lib/src/`
starter API, test, lint configuration and English README. It registers the
workspace entry and runs `fvm dart pub get`. Names must be non-reserved snake_case
and unique across repository package manifests. Existing folders are never
overwritten. Flutter mode creates a widget package, not a native plugin.

No app/feature dependency or DI registration is added automatically. Add a path
dependency in each consumer and run `make get`. Code generators are opt-in; follow
[Code generation](../CODE_GENERATION.md) if needed. Existing analyze/test commands
discover the new package automatically.

## Delete shared package

```bash
make delete-shared NAME=my_service               # checks and explains; no deletion
make delete-shared NAME=my_service CONFIRM=1
```

The command refuses deletion if another manifest references the actual package
name or a path to it, including dev dependencies and pubspec overrides. Remove
consumer imports/registrations and dependency declarations first; the command
does not edit consumers for you. Dependency detection is conservative and can
also flag ambiguous matching YAML keys; the error lists the files to inspect.
It is not an analyzer for undeclared Dart imports: run `make lint` afterwards.

Only a direct `shared/<name>/pubspec.yaml` with a matching workspace entry is
supported; symlink targets and grouped/nested packages are refused. This avoids
accidentally removing a group such as `shared/local_storage`.

After confirmation it moves the package to ignored `.scaffold-trash/`, removes
the workspace entry, and resolves dependencies. The printed backup path retains
uncommitted files too. To restore, move the backup to its original directory,
restore the workspace entry, then run `make get`. Nothing is committed by either
command. If pub get fails, the message explains the completed operation and how
to retry; creation/deletion is not silently rolled back.

## Adopt base slug for a product repo

Renames the canonical workspace slug `flutter_ffca_base` to your product package
name across workspace metadata, native bundle IDs, env defaults, and docs:

```bash
CONFIRM=1 make adopt-project PACKAGE=acme_merchant TITLE="Acme Merchant"
```
