# Feature workflow for AI agents

Apply these rules to feature packages, their app wiring, and feature scaffolding.
Use the same conventions for every feature; do not migrate only the sample.
Run commands from the workspace root. Use the project's FVM SDK and pinned dependencies.

## Commands

Replace `orders` with a snake_case feature name and `sample_app` with the target app folder.
Choose one creation command; do not run all variants for the same name.

```bash
make new-feature NAME=orders APP=sample_app                  # public route
make new-feature NAME=orders APP=sample_app DATA=remote      # remote only (default)
make new-feature NAME=orders APP=sample_app DATA=memory-cache # remote + TTL memory cache
make new-feature NAME=orders APP=sample_app DATA=persistent-cache # remote + TTL disk cache
make new-feature NAME=orders APP=sample_app DATA=offline-first # local + remote
make new-feature NAME=orders APP=sample_app DATA=local       # local storage only
make new-feature NAME=orders APP=sample_app ROUTE_KIND=tab   # shell branch
make new-feature NAME=orders APP=sample_app WIRE=0           # packages only
make get                                                  # after dependency edits
make codegen APP=sample_app                                # packages first, app last
make codegen-watch PACKAGE=features/orders/orders_data     # optional long-running watcher
make lint APP=sample_app                                   # app + all workspace libraries
make test APP=sample_app                                   # app + all workspace library tests
make codegen-check APP=sample_app                          # CI: compare generated files to HEAD
python3 -m unittest discover -s tool/scaffold -p 'test_*.py' # when scaffolding changes
```

Scaffolding resolves workspace dependencies, then generates only the new Domain/Data/Presentation packages and selected app.
`WIRE=0` skips app codegen/l10n. `make codegen` still generates the whole workspace; do not rerun it unless needed.
`codegen-check` also rejects valid uncommitted generated changes; report this, never auto-commit to pass it.
Do not start a watcher for a one-off task unless requested.

Deletion is destructive: run only when the user explicitly requests that feature's deletion.

```bash
make delete-feature NAME=orders APP=sample_app CONFIRM=1
make delete-feature NAME=orders APP=sample_app WIRE=0 CONFIRM=1 # keep app wiring; remove it manually
```

Never bypass built-in feature protection. Check consumers and remove stale routes, tabs and imports.

## Architecture and DI

- Packages: `features/<name>/<name>_domain`, `<name>_data`, `<name>_presentation`.
- Domain owns entities/contracts/use cases; no Flutter, HTTP, storage implementation or JSON imports.
- Domain use cases may use Injectable. All business/UI dependencies use constructor injection, never GetIt lookup.
- Data implements Domain contracts. Presentation depends on Domain, never Data.
- Annotate use cases with `@lazySingleton`; BLoCs with `@injectable` (factory).
- Keep each BLoC, its events, and its states in separate `*_bloc.dart`,
  `*_event.dart`, and `*_state.dart` files.
- Each dependency-owning package has `lib/di/<package>_di.dart` using `@InjectableInit.microPackage()`.
- Keep `throwOnMissingDependencies: true`; ignore only explicitly documented externally supplied types.
- Generated `.module.dart` owns internal registration. App DI selects modules, not repeated constructor bindings.
- Set `includeMicroPackages: false` in app initializers; await selected modules after shared bootstrap.
- App supplies provider configuration, storage and callbacks. Use typed `@factoryParam` callbacks for per-BLoC behavior.
- Preserve lifetimes/disposal. Pages own factory BLoCs; do not turn them into singletons.
- Use Injectable environments only for deployment/runtime environments, never
  to select a repository or datasource. App DI binds repository interfaces to
  concrete implementations explicitly.
- Do not silently register fake providers, memory token storage, duplicate implementations or unrelated features.
- Entities, DTOs and plain widgets need no DI. Do not create empty modules for symmetry.

## App wiring and generated code

- Use `apps/<app>/lib/app/features/<name>/<name>_di.dart` and `<name>_routes.dart`; no combined feature facade/manifest.
- App `di.dart` selects DI; `router/app_router.dart` selects routes/branches. Preserve `// scaffold:feature-*` markers.
- For tabs, align `app_shell.dart` destinations and branch order; scaffolding does not add tab labels/icons.
- Use typed routes and generated navigation helpers. Do not mount both generated route lists and equivalent manual routes.
- Parameterized routes need route patterns/generated trees, not concrete `.location` values as patterns.
- Use Freezed for immutable models/state, json_serializable for DTO JSON, explicit DTO-to-entity mapping.
- Never hand-edit `.g.dart`, `.freezed.dart`, `.module.dart`, `.config.dart` or `.chopper.dart`; regenerate and include outputs.

## Done means

- Preserve unrelated work and existing behavior; do not enable features beyond the request.
- Add/update English READMEs for the feature and each package, including required external providers.
- Verify package behavior, DI isolation/lifetimes/provider selection, and affected app wiring with tests.
- Run codegen, lint and tests as applicable; report exact results and any blockers. Never claim unrun checks passed.
- If changing conventions, update existing affected features, scaffold templates, tests and docs together.

Details: [DI](../tool/DEPENDENCY_INJECTION.md), [codegen](../tool/CODE_GENERATION.md), [scaffolding](../tool/scaffold/README.md).
