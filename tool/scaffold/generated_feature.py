#!/usr/bin/env python3
"""Upgrade a freshly created feature using the base's checked-in templates."""
from pathlib import Path
import sys


def generate(root, name, app, wire):
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
    deps(presentation / 'pubspec.yaml', 'dependencies', {'flutter_bloc': '^9.1.1'})
    render('domain_item.dart.template', domain / f'lib/src/{name}_item.dart')
    render('data_dto.dart.template', data / f'lib/src/{name}_item_dto.dart')
    render('presentation_bloc.dart.template', presentation / f'lib/src/{name}_bloc.dart')
    render('presentation_page.dart.template', presentation / f'lib/src/{name}_page.dart')
    for package, extra in ((domain, 'item'), (data, 'item_dto'), (presentation, 'bloc')):
        barrel = package / f'lib/{package.name}.dart'
        barrel.write_text(barrel.read_text() + f"export 'src/{name}_{extra}.dart';\n")

    write(domain / f'lib/src/{name}_repository.dart', """import '__name___item.dart';
abstract class __Pascal__Repository {
  Future<List<__Pascal__Item>> listItems();
}
""")
    use_cases = domain / f'lib/src/{name}_use_cases.dart'
    use_cases.write_text("import 'package:injectable/injectable.dart';\n" + f"import '{name}_item.dart';\n" + use_cases.read_text().replace('List<String>', f'List<{pascal}Item>').replace(f'class List{pascal}Items', f'@lazySingleton\nclass List{pascal}Items'))
    repository = data / f'lib/src/{name}_repository_impl.dart'
    repository.write_text("import 'package:injectable/injectable.dart';\n" + repository.read_text().replace('List<String>', f'List<{pascal}Item>').replace(f'class {pascal}RepositoryImpl', f"@LazySingleton(as: {pascal}Repository, env: ['local'])\nclass {pascal}RepositoryImpl"))
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
        external = f'{pascal}Repository' if layer == 'domain' else f'List{pascal}Items' if layer == 'presentation' else ''
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

## Generated conventions

- Domain: Freezed immutable item, repository contract, annotated use case; no Flutter or JSON.
- Data: Freezed + json_serializable DTO, explicit `toEntity`, repository implementation.
- Presentation: Freezed state, BLoC, injected page; no data/GetIt imports.
- Each package: `lib/di/<package>_di.dart` generates its own Injectable micro-module.
- App (when wired): explicitly selects package modules; typed route helper.

App wiring lives in `lib/app/features/__name__/`: `__name___di.dart` selects modules,
and `__name___routes.dart` owns routes and page builders. Generated companions
stay in that folder beside their source; no combined feature facade is created.

The initial repository returns an empty list. Replace its data source with your
API/database; no production fake is registered. The widget test supplies a test
double to verify the UI-to-use-case path.

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

Await `register__Pascal__Dependencies(container)` during bootstrap. The default
`local` environment installs the provided repository. To replace it, first register
your own `__Pascal__Repository`, then await the initializer with
`environment: 'custom'`. Use cases remain lazy singletons; BLoCs are factories.
Never use `GetIt.instance` in business/UI classes. Pages own and close their BLoCs.
""".replace('__app__', app))


if __name__ == '__main__':
    generate(Path(sys.argv[1]), sys.argv[2], sys.argv[3], sys.argv[4] == '1')
