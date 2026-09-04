#!/usr/bin/env python3
"""Scaffold a direct shared package or remove it with a recoverable backup.

Dependency detection is deliberately conservative and stdlib-only. It checks
package-name keys (including dev/override/inline YAML) and local path references
in pubspec files, without needing to install a YAML library before scaffolding.
"""
from datetime import datetime, timezone
from pathlib import Path
import os
import re
import sys
import uuid


SKIP = {'.git', '.dart_tool', '.fvm', 'build', 'vendor', 'Pods', '.symlinks', '.scaffold-trash', '__pycache__'}
RESERVED = set('abstract as assert async await base break case catch class const continue covariant default deferred do dynamic else enum export extends extension external factory false final finally for Function get hide if implements import in interface is late library mixin new null of on operator part required rethrow return sealed set show static super switch sync this throw true try typedef var void when while with yield'.split())


def manifests(root):
    for directory, dirs, files in os.walk(root, followlinks=False):
        dirs[:] = [name for name in dirs if name not in SKIP and not (Path(directory) / name).is_symlink()]
        for name in ('pubspec.yaml', 'pubspec_overrides.yaml'):
            if name in files:
                yield Path(directory) / name


def package_name(path):
    match = re.search(r'''(?m)^name:\s*['"]?([a-z][a-z0-9_]*)['"]?\s*(?:#.*)?$''', path.read_text())
    if not match:
        raise ValueError(f'Cannot determine package name in {path}')
    return match[1]


def target_for(root, name):
    if not re.fullmatch(r'[a-z][a-z0-9_]*', name) or name in RESERVED:
        raise ValueError('NAME must be a non-reserved snake_case Dart package name, without slashes')
    shared = root / 'shared'
    if shared.is_symlink() or not shared.is_dir():
        raise ValueError('shared must be a real directory, not a symlink')
    target = shared / name
    if target.is_symlink():
        raise ValueError('Refusing a symlink target')
    workspace = root / 'pubspec.yaml'
    if not re.search(r'(?m)^workspace:\s*$', workspace.read_text()):
        raise ValueError('Root pubspec.yaml must contain a workspace block')
    return target


def check_delete(root, name):
    target = target_for(root, name)
    if not (target / 'pubspec.yaml').is_file():
        raise ValueError('Target must be a direct package with shared/NAME/pubspec.yaml; grouped package folders are not supported')
    if any(path != target / 'pubspec.yaml' for path in target.rglob('pubspec.yaml') if not any(part in SKIP for part in path.relative_to(target).parts)):
        raise ValueError('Refusing to remove a directory containing nested packages')
    if f'  - shared/{name}' not in (root / 'pubspec.yaml').read_text().splitlines():
        raise ValueError('Target must have an exact workspace entry: "  - shared/NAME"')
    actual_name = package_name(target / 'pubspec.yaml')
    key_pattern = re.compile(r'''(?:^|[\s,{])['"]?''' + re.escape(actual_name) + r'''['"]?\s*:''', re.M)
    path_pattern = re.compile(r'''\bpath\s*:\s*(?:"([^"]+)"|'([^']+)'|([^\s,}#]+))''')
    consumers = []
    for manifest in manifests(root):
        if target in manifest.parents:
            continue
        # Strip whole comment lines; inline ambiguous references err on the safe side.
        content = '\n'.join(line for line in manifest.read_text().splitlines() if not line.lstrip().startswith('#'))
        referenced = bool(key_pattern.search(content))
        for match in path_pattern.finditer(content):
            value = next(group for group in match.groups() if group is not None)
            resolved = (manifest.parent / value).resolve()
            if resolved == target.resolve() or target.resolve() in resolved.parents:
                referenced = True
        if referenced:
            consumers.append(str(manifest.relative_to(root)))
    if consumers:
        raise ValueError('Package is still referenced; remove dependencies/dev_dependencies/overrides first:\n  ' + '\n  '.join(consumers))
    return target


def create(root, name, kind):
    target = target_for(root, name)
    if kind not in ('dart', 'flutter'):
        raise ValueError('TYPE must be dart or flutter')
    if target.exists():
        raise ValueError(f'{target} already exists; nothing was overwritten')
    for manifest in manifests(root):
        if manifest.name == 'pubspec.yaml' and package_name(manifest) == name:
            raise ValueError(f'Package name {name} is already used by {manifest.relative_to(root)}')
    title = ''.join(part.capitalize() for part in name.split('_'))
    flutter = kind == 'flutter'
    pubspec = f'''name: {name}
description: Reusable {name} shared package.
version: 1.0.0
publish_to: "none"

environment:
  sdk: ^3.6.0
resolution: workspace
'''
    if flutter:
        pubspec += '''
dependencies:
  flutter:
    sdk: flutter

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^6.0.0
'''
        implementation = f'''import 'package:flutter/widgets.dart';

/// Replace this starter widget with the package's public capability.
class {title} extends StatelessWidget {{
  const {title}({{super.key, required this.child}});

  final Widget child;

  @override
  Widget build(BuildContext context) => child;
}}
'''
        test = f'''import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:{name}/{name}.dart';

void main() {{
  testWidgets('renders its child', (tester) async {{
    await tester.pumpWidget(const {title}(child: SizedBox(key: ValueKey('child'))));
    expect(find.byKey(const ValueKey('child')), findsOneWidget);
  }});
}}
'''
    else:
        pubspec += '\ndev_dependencies:\n  lints: ^6.0.0\n  test: ^1.25.0\n'
        implementation = f'''/// Replace this starter class with the package's public capability.
class {title} {{
  const {title}();
}}
'''
        test = f'''import 'package:{name}/{name}.dart';
import 'package:test/test.dart';

void main() {{
  test('constructs the public API', () {{
    expect(const {title}(), isA<{title}>());
  }});
}}
'''
    command = 'flutter' if flutter else 'dart'
    files = {
        'pubspec.yaml': pubspec,
        'analysis_options.yaml': f'include: package:{"flutter_lints/flutter.yaml" if flutter else "lints/recommended.yaml"}\n',
        f'lib/{name}.dart': f"export 'src/{name}.dart';\n",
        f'lib/src/{name}.dart': implementation,
        f'test/{name}_test.dart': test,
        'README.md': f'''# {title}

Reusable {'Flutter' if flutter else 'pure Dart'} capability. This package contains
no app-specific composition or feature business logic. Replace the starter API
and its test with the capability you need.

## Use from an app

Add this dependency to the consuming app's pubspec (adjust the relative path
when consuming from another shared or feature package):

```yaml
dependencies:
  {name}:
    path: ../../shared/{name}
```

Run `make get` from the workspace root, then import:

```dart
import 'package:{name}/{name}.dart';
```

The scaffold registers the package in the Dart workspace only. It does not add
app dependencies, DI, routes, or code generators. Keep lifecycle and DI selection
explicit in the consuming app. See [Code generation](../../tool/CODE_GENERATION.md)
if this package later needs Freezed/JSON; add the appropriate compatible
dependencies and a direct build_runner dev dependency for codegen discovery.

## Develop and verify

From the workspace root:

```bash
cd shared/{name}
fvm dart analyze
fvm {command} test
```

## Remove

First remove this package's dependency declarations and imports from consumers.
From the workspace root:

```bash
make delete-shared NAME={name}
make delete-shared NAME={name} CONFIRM=1
```

Deletion refuses declared dependents, unregisters the workspace entry and moves
the package into ignored `.scaffold-trash/`. The command prints the backup path.
Restore by moving that backup to `shared/{name}`, restoring its workspace entry,
and running `make get`. Nested package groups require manual management.
''',
    }
    for relative, content in files.items():
        path = target / relative
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_text(content)


def main():
    mode, root, name = sys.argv[1:4]
    root = Path(root).resolve()
    if mode == 'create':
        create(root, name, sys.argv[4])
    elif mode in ('check-delete', 'delete'):
        target = check_delete(root, name)
        if mode == 'delete':
            trash = root / '.scaffold-trash'
            if trash.is_symlink():
                raise ValueError('Refusing a symlink backup directory')
            trash.mkdir(exist_ok=True)
            backup = trash / f'{name}-{datetime.now(timezone.utc):%Y%m%dT%H%M%SZ}-{uuid.uuid4().hex[:8]}'
            target.rename(backup)
            print(backup)
    else:
        raise ValueError('Unknown scaffold operation')


if __name__ == '__main__':
    try:
        main()
    except (ValueError, OSError) as error:
        print(f'error: {error}', file=sys.stderr)
        sys.exit(1)
