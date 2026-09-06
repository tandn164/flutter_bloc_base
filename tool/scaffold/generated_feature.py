#!/usr/bin/env python3
"""Upgrade a freshly created feature using the base's checked-in templates."""
from pathlib import Path
import sys


def generate(root, name, app, wire, data_strategy):
    pascal = ''.join(word.capitalize() for word in name.split('_'))
    feature = root / 'features' / name
    templates = root / 'tool/scaffold/templates/generated'

    def write(path, content):
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_text(content.replace('__name__', name).replace('__Pascal__', pascal))

    def render(template, path):
        write(path, (templates / template).read_text())

    def deps(path, section, values):
        content = path.read_text()
        lines = ''.join(f'  {key}: {value}\n' for key, value in values.items()
                        if f'  {key}:' not in content)
        if f'\n{section}:\n' not in content:
            content += f'\n{section}:\n'
        path.write_text(content.replace(f'\n{section}:\n', f'\n{section}:\n{lines}', 1))

    domain, data, presentation = [feature / f'{name}_{layer}' for layer in ('domain', 'data', 'presentation')]
    for package in (domain, data, presentation):
        deps(package / 'pubspec.yaml', 'dependencies', {'injectable': '^2.5.0', 'get_it': '^8.0.3'})
        deps(package / 'pubspec.yaml', 'dev_dependencies', {'injectable_generator': '^2.7.0'})
        deps(package / 'pubspec.yaml', 'dependencies', {'freezed_annotation': '^3.1.0'})
        deps(package / 'pubspec.yaml', 'dev_dependencies', {'build_runner': '^2.4.13', 'freezed': '3.0.6'})
    deps(data / 'pubspec.yaml', 'dependencies', {'json_annotation': '^4.9.0'})
    deps(data / 'pubspec.yaml', 'dev_dependencies', {'json_serializable': '6.9.5'})
    if data_strategy == 'memory-cache':
        deps(data / 'pubspec.yaml', 'dependencies',
             {'memory_cache': 'path: ../../../shared/memory_cache'})
    if data_strategy in ('local', 'persistent-cache', 'offline-first'):
        deps(data / 'pubspec.yaml', 'dependencies',
             {'local_storage': 'path: ../../../shared/local_storage/core'})
    deps(presentation / 'pubspec.yaml', 'dependencies', {'flutter_bloc': '^9.1.1'})
    render('domain_item.dart.template', domain / f'lib/src/{name}_item.dart')
    render('data_dto.dart.template', data / f'lib/src/{name}_item_dto.dart')
    render('presentation_bloc.dart.template', presentation / f'lib/src/{name}_bloc.dart')
    render('presentation_event.dart.template', presentation / f'lib/src/{name}_event.dart')
    render('presentation_state.dart.template', presentation / f'lib/src/{name}_state.dart')
    render('presentation_page.dart.template', presentation / f'lib/src/{name}_page.dart')
    for package, extra in ((domain, 'item'), (data, 'item_dto')):
        barrel = package / f'lib/{package.name}.dart'
        barrel.write_text(barrel.read_text() + f"export 'src/{name}_{extra}.dart';\n")
    presentation_barrel = presentation / f'lib/{presentation.name}.dart'
    presentation_barrel.write_text(
        presentation_barrel.read_text()
        + f"export 'src/{name}_bloc.dart';\n"
        + f"export 'src/{name}_event.dart';\n"
        + f"export 'src/{name}_state.dart';\n"
    )

    write(domain / f'lib/src/{name}_repository.dart', """import '__name___item.dart';
abstract class __Pascal__Repository {
  Future<List<__Pascal__Item>> listItems();
}
""")
    use_cases = domain / f'lib/src/{name}_use_cases.dart'
    use_cases.write_text("import 'package:injectable/injectable.dart';\n" + f"import '{name}_item.dart';\n" + use_cases.read_text().replace('List<String>', f'List<{pascal}Item>').replace(f'class List{pascal}Items', f'@lazySingleton\nclass List{pascal}Items'))
    repository = data / f'lib/src/{name}_repository_impl.dart'
    remote_type = f'{pascal}RemoteDataSource'
    local_type = f'{pascal}LocalDataSource'
    if data_strategy in ('remote', 'memory-cache', 'persistent-cache', 'offline-first'):
        write(data / f'lib/src/{name}_remote_data_source.dart', f'''import '{name}_item_dto.dart';

abstract interface class {remote_type} {{
  Future<List<{pascal}ItemDto>> fetchAll();
}}
''')
        barrel = data / f'lib/{data.name}.dart'
        barrel.write_text(barrel.read_text() + f"export 'src/{name}_remote_data_source.dart';\n")
    if data_strategy in ('local', 'offline-first'):
        write(data / f'lib/src/{name}_local_data_source.dart', f'''import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:local_storage/local_storage.dart';
import '{name}_item_dto.dart';

abstract interface class {local_type} {{
  Future<List<{pascal}ItemDto>> readAll();
  Future<void> replaceAll(List<{pascal}ItemDto> items);
}}

@LazySingleton(as: {local_type})
class KeyValue{pascal}LocalDataSource implements {local_type} {{
  KeyValue{pascal}LocalDataSource(this.store);
  final KeyValueStore store;
  static const _key = '{name}.items.v1';

  @override
  Future<List<{pascal}ItemDto>> readAll() async {{
    final value = await store.readString(_key);
    if (value == null) return const [];
    final values = jsonDecode(value) as List<dynamic>;
    return values
        .map((item) => {pascal}ItemDto.fromJson(item as Map<String, dynamic>))
        .toList(growable: false);
  }}

  @override
  Future<void> replaceAll(List<{pascal}ItemDto> items) =>
      store.writeString(_key, jsonEncode(items.map((item) => item.toJson()).toList()));
}}
''')
        barrel = data / f'lib/{data.name}.dart'
        barrel.write_text(barrel.read_text() + f"export 'src/{name}_local_data_source.dart';\n")

    if data_strategy == 'remote':
        repository_source = f'''import 'package:injectable/injectable.dart';
import 'package:{name}_domain/{name}_domain.dart';
import '{name}_item_dto.dart';
import '{name}_remote_data_source.dart';

@LazySingleton()
class {pascal}RepositoryImpl implements {pascal}Repository {{
  {pascal}RepositoryImpl(this.remote);
  final {remote_type} remote;

  @override
  Future<List<{pascal}Item>> listItems() async =>
      [for (final item in await remote.fetchAll()) item.toEntity()];
}}
'''
    elif data_strategy == 'memory-cache':
        repository_source = f'''import 'package:injectable/injectable.dart';
import 'package:memory_cache/memory_cache.dart';
import 'package:{name}_domain/{name}_domain.dart';
import '{name}_item_dto.dart';
import '{name}_remote_data_source.dart';

@LazySingleton()
class {pascal}RepositoryImpl implements {pascal}Repository {{
  {pascal}RepositoryImpl(this.remote, {{Duration ttl = const Duration(minutes: 10)}})
      : cache = MemoryTtlCache(ttl: ttl);
  @factoryMethod
  static {pascal}RepositoryImpl create({remote_type} remote) =>
      {pascal}RepositoryImpl(remote);
  final {remote_type} remote;
  final MemoryTtlCache<String, List<{pascal}Item>> cache;

  @override
  Future<List<{pascal}Item>> listItems() async {{
    final cached = cache.read('items');
    if (cached != null) return cached;
    final items = [for (final item in await remote.fetchAll()) item.toEntity()];
    cache.write('items', items);
    return items;
  }}
}}
'''
    elif data_strategy == 'persistent-cache':
        repository_source = f'''import 'package:injectable/injectable.dart';
import 'package:local_storage/local_storage.dart';
import 'package:{name}_domain/{name}_domain.dart';
import '{name}_item_dto.dart';
import '{name}_remote_data_source.dart';

@LazySingleton()
class {pascal}RepositoryImpl implements {pascal}Repository {{
  {pascal}RepositoryImpl(
    this.remote,
    KeyValueStore store, {{
    Duration ttl = const Duration(minutes: 30),
  }}) : cache = PersistentJsonCache(
          store: store,
          key: '{name}.cache.v1',
          ttl: ttl,
        );
  @factoryMethod
  static {pascal}RepositoryImpl create(
    {remote_type} remote,
    KeyValueStore store,
  ) => {pascal}RepositoryImpl(remote, store);

  final {remote_type} remote;
  final PersistentJsonCache cache;

  @override
  Future<List<{pascal}Item>> listItems() async {{
    final cached = await cache.read();
    if (cached case final List<dynamic> values) {{
      return values
          .map((item) => {pascal}ItemDto.fromJson(item as Map<String, dynamic>))
          .map((item) => item.toEntity())
          .toList(growable: false);
    }}
    final fresh = await remote.fetchAll();
    await cache.write(fresh.map((item) => item.toJson()).toList());
    return [for (final item in fresh) item.toEntity()];
  }}
}}
'''
    elif data_strategy == 'local':
        repository_source = f'''import 'package:injectable/injectable.dart';
import 'package:{name}_domain/{name}_domain.dart';
import '{name}_item_dto.dart';
import '{name}_local_data_source.dart';

@LazySingleton()
class {pascal}RepositoryImpl implements {pascal}Repository {{
  {pascal}RepositoryImpl(this.local);
  final {local_type} local;

  @override
  Future<List<{pascal}Item>> listItems() async =>
      [for (final item in await local.readAll()) item.toEntity()];
}}
'''
    else:
        repository_source = f'''import 'package:injectable/injectable.dart';
import 'package:{name}_domain/{name}_domain.dart';
import '{name}_item_dto.dart';
import '{name}_local_data_source.dart';
import '{name}_remote_data_source.dart';

@LazySingleton()
class {pascal}RepositoryImpl implements {pascal}Repository {{
  {pascal}RepositoryImpl(this.local, this.remote);
  final {local_type} local;
  final {remote_type} remote;

  @override
  Future<List<{pascal}Item>> listItems() async {{
    final localItems = await local.readAll();
    try {{
      final fresh = await remote.fetchAll();
      await local.replaceAll(fresh);
      return [for (final item in fresh) item.toEntity()];
    }} catch (_) {{
      if (localItems.isNotEmpty) {{
        return [for (final item in localItems) item.toEntity()];
      }}
      rethrow;
    }}
  }}
}}
'''
    write(repository, repository_source)
    for package in (domain, data, presentation):
        layer = package.name.removeprefix(name + '_')
        write(package / 'README.md', f'''# {package.name}

The {layer} package for the {name} feature. See [feature usage](../README.md)
for the complete architecture and app wiring instructions.

## Dependency injection

This package owns `lib/di/{package.name}_di.dart`. Injectable generates the
adjacent `.module.dart` from constructor annotations. Importing the package
does not initialize DI; the app explicitly selects its module. Business classes
use constructor injection and can be instantiated directly in tests.

Run `make codegen APP={app}` from the workspace root after changing annotations.
Commit generated sources, including `.module.dart`; never edit them by hand.
Run package tests and the selected app tests before submitting changes.
''')
        imports = f"import 'package:{name}_domain/{name}_domain.dart';\n" if layer != 'data' else ''
        if layer == 'data':
            if data_strategy in ('remote', 'memory-cache', 'persistent-cache', 'offline-first'):
                imports += f"import '../src/{name}_remote_data_source.dart';\n"
            if data_strategy in ('local', 'persistent-cache', 'offline-first'):
                imports += "import 'package:local_storage/local_storage.dart';\n"
            if data_strategy in ('local', 'offline-first'):
                imports += f"import '../src/{name}_local_data_source.dart';\n"
        if layer == 'domain':
            external = f'{pascal}Repository'
        elif layer == 'presentation':
            external = f'List{pascal}Items'
        else:
            external_types = []
            if data_strategy in ('remote', 'memory-cache', 'persistent-cache', 'offline-first'):
                external_types.append(remote_type)
            if data_strategy in ('local', 'persistent-cache', 'offline-first'):
                external_types.append('KeyValueStore')
            external = ', '.join(external_types)
        write(package / f'lib/di/{package.name}_di.dart',
              "import 'package:injectable/injectable.dart';\n" + imports +
              f'\n@InjectableInit.microPackage(throwOnMissingDependencies: true, ignoreUnregisteredTypes: [{external}])\n'
              f'void init{pascal}{layer.capitalize()}Module() {{}}\n')
    write(domain / f'test/{name}_use_cases_test.dart', """import 'package:__name___domain/__name___domain.dart';
import 'package:test/test.dart';
class _Repository implements __Pascal__Repository {
  @override
  Future<List<__Pascal__Item>> listItems() async => const [__Pascal__Item(id: '1', title: 'Sample')];
}
void main() {
  test('use case delegates; generated equality and copyWith work', () async {
    final items = await List__Pascal__Items(_Repository())();
    expect(items.single.copyWith(title: 'Changed'), const __Pascal__Item(id: '1', title: 'Changed'));
  });
}
""")
    write(data / f'test/{name}_dto_test.dart', """import 'package:__name___data/__name___data.dart';
import 'package:test/test.dart';
void main() {
  test('DTO JSON round-trip and explicit entity mapping', () {
    const dto = __Pascal__ItemDto(id: '1', title: 'Sample');
    expect(__Pascal__ItemDto.fromJson(dto.toJson()), dto);
    expect(dto.toEntity().id, '1');
  });
}
""")
    if data_strategy in ('remote', 'memory-cache'):
        repository_test = f'''import 'package:{name}_data/{name}_data.dart';
import 'package:test/test.dart';

class _Remote implements {remote_type} {{
  var calls = 0;
  @override
  Future<List<{pascal}ItemDto>> fetchAll() async {{
    calls++;
    return const [{pascal}ItemDto(id: '1', title: 'Sample')];
  }}
}}

void main() {{
  test('repository uses the selected {data_strategy} strategy', () async {{
    final remote = _Remote();
    final repository = {pascal}RepositoryImpl(remote);
    await repository.listItems();
    await repository.listItems();
    expect(remote.calls, {1 if data_strategy == 'memory-cache' else 2});
  }});
}}
'''
    elif data_strategy == 'persistent-cache':
        repository_test = f'''import 'package:{name}_data/{name}_data.dart';
import 'package:local_storage/local_storage.dart';
import 'package:test/test.dart';

class _Remote implements {remote_type} {{
  var calls = 0;
  @override
  Future<List<{pascal}ItemDto>> fetchAll() async {{
    calls++;
    return const [{pascal}ItemDto(id: '1', title: 'Remote')];
  }}
}}

void main() {{
  test('repository reuses disk cache after recreation', () async {{
    final remote = _Remote();
    final store = MemoryKeyValueStore();
    await {pascal}RepositoryImpl(remote, store).listItems();
    await {pascal}RepositoryImpl(remote, store).listItems();
    expect(remote.calls, 1);
  }});
}}
'''
    elif data_strategy == 'local':
        repository_test = f'''import 'package:{name}_data/{name}_data.dart';
import 'package:test/test.dart';

class _Local implements {local_type} {{
  @override
  Future<List<{pascal}ItemDto>> readAll() async =>
      const [{pascal}ItemDto(id: '1', title: 'Local')];
  @override
  Future<void> replaceAll(List<{pascal}ItemDto> items) async {{}}
}}

void main() {{
  test('repository reads local storage only', () async {{
    final items = await {pascal}RepositoryImpl(_Local()).listItems();
    expect(items.single.title, 'Local');
  }});
}}
'''
    else:
        repository_test = f'''import 'package:{name}_data/{name}_data.dart';
import 'package:test/test.dart';

class _Local implements {local_type} {{
  List<{pascal}ItemDto> items = const [{pascal}ItemDto(id: '1', title: 'Local')];
  @override
  Future<List<{pascal}ItemDto>> readAll() async => items;
  @override
  Future<void> replaceAll(List<{pascal}ItemDto> value) async => items = value;
}}
class _Remote implements {remote_type} {{
  @override
  Future<List<{pascal}ItemDto>> fetchAll() async =>
      const [{pascal}ItemDto(id: '2', title: 'Remote')];
}}

void main() {{
  test('repository refreshes local data from remote', () async {{
    final local = _Local();
    final items = await {pascal}RepositoryImpl(local, _Remote()).listItems();
    expect(items.single.title, 'Remote');
    expect(local.items.single.id, '2');
  }});
}}
'''
    write(data / f'test/{name}_repository_impl_test.dart', repository_test)
    write(presentation / f'test/{name}_page_test.dart', """import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:__name___domain/__name___domain.dart';
import 'package:__name___presentation/__name___presentation.dart';
class _Repository implements __Pascal__Repository {
  @override
  Future<List<__Pascal__Item>> listItems() async => const [__Pascal__Item(id: '1', title: 'Loaded item')];
}
void main() {
  testWidgets('UI loads items through BLoC and use case', (tester) async {
    await tester.pumpWidget(MaterialApp(home: __Pascal__Page(
      createBloc: () => __Pascal__Bloc(List__Pascal__Items(_Repository())),
    )));
    await tester.pumpAndSettle();
    expect(find.text('Loaded item'), findsOneWidget);
  });
}
""")
    if wire:
        app_dir = root / 'apps' / app
        deps(app_dir / 'pubspec.yaml', 'dependencies', {'injectable': '^2.5.0'})
        deps(app_dir / 'pubspec.yaml', 'dev_dependencies', {
            'build_runner': '^2.4.13', 'injectable_generator': '^2.7.0', 'go_router_builder': '2.8.2'})
        render('app_di.dart.template', app_dir / f'lib/app/features/{name}/{name}_di.dart')
        render('app_routes.dart.template', app_dir / f'lib/app/features/{name}/{name}_routes.dart')

    write(feature / 'README.md', """# __Pascal__ feature

Data strategy: `__data_strategy__`.

## Generated conventions

- Domain: Freezed immutable item, repository contract, annotated use case; no Flutter or JSON.
- Data: Freezed + json_serializable DTO, explicit `toEntity`, repository implementation.
- Presentation: Freezed state, BLoC, injected page; no data/GetIt imports.
- Each package: `lib/di/<package>_di.dart` generates its own Injectable micro-module.
- App (when wired): explicitly selects package modules; typed route helper.

App wiring lives in `lib/app/features/__name__/`: `__name___di.dart` selects modules,
and `__name___routes.dart` owns routes and page builders. Generated companions
stay in that folder beside their source; no combined feature facade is created.

The repository is generated for the selected `__data_strategy__` strategy.
Register required remote providers and `KeyValueStore` adapters in app DI; no
production fake is registered. The widget test supplies a test double to verify
the UI-to-use-case path.

## Generate and test

Run `make codegen APP=__app__` after editing models, bindings, or route annotations.
Use `make codegen-watch PACKAGE=features/__name__/__name___data` during development.
Do not edit generated `.freezed.dart`, `.g.dart`, `.module.dart`, or `.config.dart` files; commit them.
Run `make test APP=__app__` and `make codegen-check APP=__app__` before submitting.

## Enable / disable

When wired, app `di.dart` selects this feature's dependency initializer and
`app_router.dart` selects its routes/branch. For tabs, update destinations in
`app_shell.dart` to match. Keep registration explicit; do not scan/register every feature globally.
For `WIRE=0`, packages are created without app imports or registrations.

Await `register__Pascal__Dependencies(container)` during bootstrap. The app
explicitly binds `__Pascal__Repository` to the generated concrete repository.
To replace it, register your own contract implementation before the initializer.
Use cases remain lazy singletons; BLoCs are factories.
Never use `GetIt.instance` in business/UI classes. Pages own and close their BLoCs.
""".replace('__app__', app).replace('__data_strategy__', data_strategy))


if __name__ == '__main__':
    generate(Path(sys.argv[1]), sys.argv[2], sys.argv[3], sys.argv[4] == '1', sys.argv[5])
