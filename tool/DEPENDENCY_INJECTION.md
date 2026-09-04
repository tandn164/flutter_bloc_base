# Package-owned dependency injection

Sample, Onboarding, Auth, Profile and newly scaffolded features use the same convention:
annotations live beside classes, package modules own internal registration, and
the app explicitly selects modules and supplies shared services. Auth/Profile have
complete package modules but are not enabled in sample_app. Direct constructors
remain usable without DI in every feature.

## Add a dependency

1. Add a constructor parameter to the consuming class.
2. Annotate the class: `@injectable` for a fresh instance, `@lazySingleton` for a
   shared service/use case, or `@LazySingleton(as: Contract, env: ['local'])`
   for an environment-selected implementation.
3. Run `make codegen APP=sample_app`. Package modules are generated before app DI.
4. Run tests. App code does not need to repeat the constructor call.

Domain use cases may import Injectable annotations; entities and repository
contracts do not need them. Domain still has no Flutter, HTTP or storage dependency.
Constructor injection remains mandatory: no `GetIt.instance` service lookup in
business or UI classes. Tests may instantiate annotated classes directly.

## Package modules

Each package that registers dependencies has `lib/di/<package>_di.dart` with
`@InjectableInit.microPackage()`. The generated `.module.dart` is a public DI
entry point, imported explicitly by the app; keep the normal package barrel free
of DI exports. Packages declare Injectable/GetIt and the generator dependencies.

`ignoreUnregisteredTypes` lists only contracts supplied by another selected
module or app bootstrap. `throwOnMissingDependencies: true` catches other missing
bindings at generation time; ignored types still must exist when resolved.

Use `@factoryMethod` when a default constructor contains configuration parameters
that should use defaults rather than be resolved from DI. Sample's local repository
and Onboarding's stored repository demonstrate this without changing direct callers.

## App composition

`lib/app/features/<name>/<name>_di.dart` lists `ExternalModule` entries in dependency
order: Data, Domain, Presentation. It contains no duplicate constructor bindings.
Set `includeMicroPackages: false` so unrelated packages are never auto-enabled.
`app/di.dart` awaits selected feature initializers after registering shared resources.
The app owns the container; importing a package never initializes it.

```dart
final container = GetIt.asNewInstance();
await registerSampleDependencies(container); // local implementation
final bloc = container<SampleBloc>();        // new instance each time
// Its page/BlocProvider owns close(), not a singleton container registration.
```

To replace the repository without duplicate registrations:

```dart
container.registerSingleton<SampleRepository>(myRepository);
await registerSampleDependencies(container, environment: 'custom');
```

The `local` environment enables the package's default repository; `custom` does
not. These are DI provider choices, not the app's dev/staging/prod build flavors.
Use cases and BLoCs are environment-independent. For Onboarding, the same
choice applies to `OnboardingRepository`; local mode requires a `KeyValueStore`
from app bootstrap. Unknown environments also omit local bindings, so test every
selected configuration and supply required contracts explicitly.

To disable a feature, omit its initializer and routes. Do not invoke an initializer
twice on the same container or turn on silent registration overrides.

Injectable caches its environment filter per container. Select one consistent
environment when composing multiple initializers; do not pass `local` to one
initializer and `remote` to another on the same container. For mixed/custom
providers, use `custom` consistently and supply the repository contracts from
the app. If defining new combined environment filters, avoid enabling both
Sample's local and remote bindings for the same contract.

## Files, generation and tests

- Edit annotated classes and `*_di.dart`; never hand-edit generated files.
- Commit package `.module.dart` and app `.config.dart` outputs.
- `make new-feature` creates all three package modules, annotations, app module
  selection, typed routes and tests. `WIRE=0` still creates package DI without an app.
- `make delete-feature` removes that feature's packages and app wiring.
- App tests cover opt-in registration, custom repository selection, missing
  contracts, container isolation and distinct BLoC instances.

See [code generation](CODE_GENERATION.md) for commands and generator compatibility.

## Auth and Profile integration

Select `AuthDataPackageModule`, `AuthDomainPackageModule`,
`AuthPresentationPackageModule` (or the three Profile modules) in the app's
`externalPackageModulesBefore` list, with `includeMicroPackages: false`.
Await the generated initializer with `environment: 'remote'`.
Do not register the same API/repository separately when using the data module.

App-provided inputs:

- Auth remote: configured `ChopperClient`, `ApiTransport` for token refresh,
  `TokenVault` and `AuthSessionConfig`. The refresh transport must not use the
  authenticated session interceptor, avoiding recursive refresh.
- Profile remote: configured `ChopperClient`.
- Sample remote: configured `DataGateway`. Local still selects its local repository.
- Onboarding local: `KeyValueStore`.

Auth's data module creates a lazy `Session` and disposes it on container reset.
Register `const AuthSessionConfig(guestAllowed: false)` to require login; call
`restore()` explicitly during app bootstrap when desired. No memory vault or
persistence callback is selected silently. `MemoryTokenVault` and
`PrefsTokenVault` are app-chosen storage adapters, not automatic defaults.

For custom providers, select `custom` and supply the repository contracts
yourself. Auth's remote session/refresher bindings are also omitted in custom
mode; the app owns its replacement session.

BLoCs use factories. Auth/Profile callbacks are `@factoryParam` dependencies:

```dart
final login = container<LoginBloc>(
  param1: (TokenPair tokens) async {
    await container<Session>().signIn(
      accessToken: tokens.accessToken,
      refreshToken: tokens.refreshToken,
    );
  },
);
final profile = container<ProfileBloc>(
  param1: () async => container<Session>().signOut(),
);
```

Supply a callback on every resolve (SignupBloc follows LoginBloc). The page owns
BLoC disposal; callbacks are not global container bindings. Entities, DTOs and
plain widgets need no DI annotation. Onboarding Presentation has no injectable
service/BLoC, so no empty module is generated.
