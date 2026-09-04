#!/usr/bin/env python3
"""Wire/unwire feature adapters directly in app DI and router source files."""
from pathlib import Path
import re
import sys


def update(mode, app, name, pascal, route_kind):
    if not re.fullmatch(r'[a-z][a-z0-9_]*', name):
        raise ValueError('Invalid feature name')
    if route_kind not in ('public', 'tab'):
        raise ValueError('ROUTE_KIND must be public or tab')
    paths = [app / 'lib/app/di.dart', app / 'lib/app/router/app_router.dart']
    texts = [path.read_text() for path in paths]
    markers = [('scaffold:feature-imports', 'scaffold:feature-registrations'),
               ('scaffold:feature-imports', 'scaffold:feature-routes', 'scaffold:feature-branches')]
    if mode in ('check', 'wire'):
        for path, text, required in zip(paths, texts, markers):
            for marker in required:
                if text.count('// ' + marker) != 1:
                    raise ValueError(f'{path} must contain exactly one // {marker}; restore the scaffold marker or use WIRE=0')
        if mode == 'check':
            return

    def insert(text, marker, line):
        if line.strip() in [existing.strip() for existing in text.splitlines()]:
            return text
        pattern = r'(?m)^([ \t]*)// ' + re.escape(marker) + r'\s*$'
        return re.sub(pattern, lambda m: m[1] + line + '\n' + m[1] + '// ' + marker, text, count=1)

    if mode == 'wire':
        texts[0] = insert(texts[0], 'scaffold:feature-imports', f"import 'features/{name}/{name}_di.dart';")
        texts[0] = insert(texts[0], 'scaffold:feature-registrations', f'await register{pascal}Dependencies(sl);')
        texts[1] = insert(texts[1], 'scaffold:feature-imports', f"import '../features/{name}/{name}_routes.dart';")
        if route_kind == 'tab':
            texts[1] = insert(texts[1], 'scaffold:feature-branches', f'create{pascal}Branch(sl),')
        else:
            texts[1] = insert(texts[1], 'scaffold:feature-routes', f'...create{pascal}Routes(sl),')
    elif mode == 'unwire':
        remove = {
            f'await register{pascal}Dependencies(sl);',
            f"import 'features/{name}/{name}_di.dart';",
            f"import '../features/{name}/{name}_routes.dart';",
            f"import 'features/{name}_feature.dart';",
            f"import '../features/{name}_feature.dart';",
            f'register{pascal}Dependencies(sl);',
            f'...create{pascal}Routes(sl),',
            f'create{pascal}Branch(sl),',
        }
        # Remove only exact scaffold-owned statements, preserving other features.
        texts = ['\n'.join(line for line in text.splitlines() if line.strip() not in remove) + '\n' for text in texts]
    else:
        raise ValueError('Unknown wiring mode')
    for path, text in zip(paths, texts):
        path.write_text(text)


if __name__ == '__main__':
    try:
        update(sys.argv[1], Path(sys.argv[2]), sys.argv[3], sys.argv[4], sys.argv[5])
    except (ValueError, OSError) as error:
        print(f'error: {error}', file=sys.stderr)
        sys.exit(1)
