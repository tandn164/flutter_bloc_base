"""Scaffold regression checks without network access or repository mutations."""
import os
from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest


class GeneratedFeatureTest(unittest.TestCase):
    def test_package_modules_are_generated_before_app(self):
        source = Path(__file__).resolve().parents[2]
        result = subprocess.run(
            ['bash', '-c', 'source tool/package_utils.sh; codegen_packages'],
            cwd=source, env=dict(os.environ, APP='sample_app'),
            capture_output=True, text=True, check=True,
        )
        packages = result.stdout.splitlines()
        self.assertEqual(packages[-1], 'apps/sample_app')
        self.assertIn('features/sample/sample_domain', packages[:-1])
        self.assertIn('features/onboarding/onboarding_data', packages[:-1])

    def test_two_tabs_and_unwired_feature(self):
        source = Path(__file__).resolve().parents[2]
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            shutil.copytree(source / 'tool/scaffold', root / 'tool/scaffold')
            shutil.copyfile(source / 'tool/codegen_all.sh', root / 'tool/codegen_all.sh')
            shutil.copyfile(source / 'tool/package_utils.sh', root / 'tool/package_utils.sh')
            unrelated = root / 'shared/unrelated'
            unrelated.mkdir(parents=True)
            (unrelated / 'pubspec.yaml').write_text('name: unrelated\ndev_dependencies:\n  build_runner: ^2.4.13\n')
            (root / 'pubspec.yaml').write_text('name: fixture\nworkspace:\n  - apps/sample_app\ndev_dependencies:\n  test: ^1.25.0\n')
            app = root / 'apps/sample_app'
            (app / 'lib/app/features').mkdir(parents=True)
            (app / 'pubspec.yaml').write_text('name: sample_app\ndependencies:\n  get_it: ^8.0.3\n  go_router: ^14.6.2\ndev_dependencies:\n  test: ^1.25.0\n')
            (app / 'lib/app/router').mkdir()
            app_di = app / 'lib/app/di.dart'
            router = app / 'lib/app/router/app_router.dart'
            shutil.copyfile(source / 'apps/sample_app/lib/app/di.dart', app_di)
            shutil.copyfile(source / 'apps/sample_app/lib/app/router/app_router.dart', router)
            bin_dir = root / 'bin'
            bin_dir.mkdir()
            fvm = bin_dir / 'fvm'
            fvm.write_text('#!/bin/sh\nprintf "%s|%s\\n" "$PWD" "$*" >> "$SCAFFOLD_CALL_LOG"\n'
                           'if [ "$PWD" = "$FAIL_PACKAGE" ] && [ "$1 $2" = "dart run" ]; then exit 9; fi\nexit 0\n')
            fvm.chmod(0o755)
            log = root / 'calls.log'
            env = dict(os.environ, PATH=f'{bin_dir}:{os.environ["PATH"]}', APP='sample_app', ROUTE_KIND='tab',
                       USE_SYSTEM_SDK='0', SCAFFOLD_CALL_LOG=str(log), FAIL_PACKAGE='')
            cases = [
                ('order_history', '1', 'tab', 'remote'),
                ('inventory', '1', 'tab', 'memory-cache'),
                ('news', '1', 'public', 'persistent-cache'),
                ('reports', '1', 'public', 'offline-first'),
                ('detached', '0', 'public', 'local'),
            ]
            for name, wire, kind, data in cases:
                log.write_text('')
                result = subprocess.run(['bash', str(root / 'tool/scaffold/new_feature.sh')],
                                        env=dict(env, NAME=name, WIRE=wire, ROUTE_KIND=kind, DATA=data), capture_output=True, text=True)
                self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
                expected = [f'{root}|dart pub get']
                expected += [f'{root}/features/{name}/{name}_{layer}|dart run build_runner build --delete-conflicting-outputs'
                             for layer in ('domain', 'data', 'presentation')]
                if wire == '1':
                    expected += [f'{app}|flutter gen-l10n', f'{app}|dart run build_runner build --delete-conflicting-outputs']
                self.assertEqual(log.read_text().splitlines(), expected)
                dto = root / f'features/{name}/{name}_data/lib/src/{name}_item_dto.dart'
                self.assertIn('@freezed', dto.read_text())
                self.assertNotIn('__name__', dto.read_text())
                data_lib = root / f'features/{name}/{name}_data/lib'
                self.assertEqual((data_lib / f'src/{name}_remote_data_source.dart').exists(),
                                 data in ('remote', 'memory-cache', 'persistent-cache', 'offline-first'))
                self.assertEqual((data_lib / f'src/{name}_local_data_source.dart').exists(),
                                 data in ('local', 'offline-first'))
                data_pubspec = (root / f'features/{name}/{name}_data/pubspec.yaml').read_text()
                self.assertEqual('memory_cache:' in data_pubspec, data == 'memory-cache')
                self.assertEqual('local_storage:' in data_pubspec,
                                 data in ('local', 'persistent-cache', 'offline-first'))
                bloc_dir = root / f'features/{name}/{name}_presentation/lib/src'
                self.assertTrue((bloc_dir / f'{name}_bloc.dart').exists())
                self.assertTrue((bloc_dir / f'{name}_event.dart').exists())
                self.assertTrue((bloc_dir / f'{name}_state.dart').exists())
                self.assertNotIn(f'class {name.title().replace("_", "")}Event',
                                 (bloc_dir / f'{name}_bloc.dart').read_text())
                for layer in ('domain', 'data', 'presentation'):
                    package = root / f'features/{name}/{name}_{layer}'
                    self.assertGreater(len((package / 'README.md').read_text()), 80)
                    self.assertIn('@InjectableInit.microPackage(',
                                  (package / f'lib/di/{name}_{layer}_di.dart').read_text())
            self.assertIn('createOrderHistoryBranch(sl)', router.read_text())
            workspace = (root / 'pubspec.yaml').read_text()
            self.assertLess(workspace.index('  - features/order_history/'), workspace.index('dev_dependencies:'))
            self.assertIn('createInventoryBranch(sl)', router.read_text())
            self.assertIn('...createReportsRoutes(sl)', router.read_text())
            self.assertIn('registerOrderHistoryDependencies(sl)', app_di.read_text())
            self.assertIn('registerInventoryDependencies(sl)', app_di.read_text())
            self.assertIn('registerReportsDependencies(sl)', app_di.read_text())
            self.assertNotIn('detached', router.read_text() + app_di.read_text())
            self.assertFalse(list((app / 'lib/app/features').glob('*.dart')))
            self.assertFalse((app / 'lib/app/features/detached').exists())
            di = app / 'lib/app/features/order_history/order_history_di.dart'
            self.assertIn("generateForDir: ['lib/app/features/order_history']", di.read_text())
            self.assertIn('registerOrderHistoryDependencies', di.read_text())
            for name in ('order_history', 'inventory', 'reports'):
                source_di = (app / f'lib/app/features/{name}/{name}_di.dart').read_text()
                self.assertIn('@InjectableInit(', source_di)
                self.assertIn('includeMicroPackages: false', source_di)
                self.assertIn('ExternalModule(', source_di)
                self.assertNotIn('@module', source_di)
                self.assertIn(f"import '{name}_di.config.dart';", source_di)
                self.assertIn('registerLazySingleton', source_di)
                self.assertNotIn('environment:', source_di)
                self.assertIn('await register', app_di.read_text())
                for layer in ('domain', 'data', 'presentation'):
                    package = root / f'features/{name}/{name}_{layer}'
                    module = package / f'lib/di/{name}_{layer}_di.dart'
                    self.assertIn('@InjectableInit.microPackage(', module.read_text())
                    self.assertIn('injectable_generator:', (package / 'pubspec.yaml').read_text())
                    self.assertGreater(len((package / 'README.md').read_text()), 80)
            routes = app / 'lib/app/features/order_history/order_history_routes.dart'
            self.assertIn("part 'order_history_routes.g.dart';", routes.read_text())
            self.assertIn("import '../../di.dart' as app_di;", routes.read_text())
            self.assertNotIn('registerOrderHistoryDependencies', routes.read_text())
            self.assertIn("features/order_history/order_history_di.dart", app_di.read_text())
            self.assertIn("features/order_history/order_history_routes.dart", router.read_text())
            # Simulate codegen outputs so deletion covers companion files too.
            for suffix in ('di.config.dart', 'routes.g.dart'):
                (di.parent / f'order_history_{suffix}').write_text('// generated\n')

            result = subprocess.run(['bash', str(root / 'tool/scaffold/delete_feature.sh')],
                                    env=dict(env, NAME='order_history', CONFIRM='1'), capture_output=True, text=True)
            self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
            self.assertNotIn('OrderHistory', router.read_text() + app_di.read_text())
            self.assertNotIn('order_history_feature.dart', router.read_text() + app_di.read_text())
            self.assertNotIn('features/order_history/', router.read_text() + app_di.read_text())
            self.assertFalse(di.parent.exists())
            self.assertTrue((app / 'lib/app/features/inventory/inventory_routes.dart').exists())
            self.assertIn('createInventoryBranch(sl)', router.read_text())
            self.assertIn('registerReportsDependencies(sl)', app_di.read_text())

            # The separate full-workspace command must still visit other packages.
            log.write_text('')
            result = subprocess.run(['bash', str(root / 'tool/codegen_all.sh')],
                                    env=env, capture_output=True, text=True)
            self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
            generated = [line.split('|')[0] for line in log.read_text().splitlines()
                         if '|dart run build_runner ' in line]
            expected_packages = {str(unrelated), str(app)}
            expected_packages.update(str(root / f'features/{name}/{name}_{layer}')
                                     for name in ('inventory', 'news', 'reports', 'detached')
                                     for layer in ('domain', 'data', 'presentation'))
            self.assertEqual(set(generated), expected_packages)
            self.assertEqual(generated[-1], str(app))

            # A failed package generation stops before later packages/app generation.
            log.write_text('')
            result = subprocess.run(['bash', str(root / 'tool/scaffold/new_feature.sh')],
                                    env=dict(env, NAME='broken', WIRE='1',
                                             FAIL_PACKAGE=str(root / 'features/broken/broken_data')),
                                    capture_output=True, text=True)
            self.assertNotEqual(result.returncode, 0)
            self.assertEqual(len(log.read_text().splitlines()), 3) # pub get, domain, data
            self.assertNotIn(f'{app}|', log.read_text())

            # Fail before creating files if an app cannot be safely wired.
            app_di.write_text(app_di.read_text().replace('// scaffold:feature-registrations', ''))
            result = subprocess.run(['bash', str(root / 'tool/scaffold/new_feature.sh')],
                                    env=dict(env, NAME='invalid_wiring', WIRE='1'), capture_output=True, text=True)
            self.assertNotEqual(result.returncode, 0)
            self.assertFalse((root / 'features/invalid_wiring').exists())

            result = subprocess.run(['bash', str(root / 'tool/scaffold/new_feature.sh')],
                                    env=dict(env, NAME='invalid_data', DATA='magic'),
                                    capture_output=True, text=True)
            self.assertNotEqual(result.returncode, 0)
            self.assertFalse((root / 'features/invalid_data').exists())


if __name__ == '__main__':
    unittest.main()
