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
            (root / 'tool/codegen_all.sh').write_text('#!/bin/sh\nexit 0\n')
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
            fvm.write_text('#!/bin/sh\nexit 0\n')
            fvm.chmod(0o755)
            env = dict(os.environ, PATH=f'{bin_dir}:{os.environ["PATH"]}', APP='sample_app', ROUTE_KIND='tab')
            for name, wire, kind in [('order_history', '1', 'tab'), ('inventory', '1', 'tab'), ('reports', '1', 'public'), ('detached', '0', 'public')]:
                result = subprocess.run(['bash', str(root / 'tool/scaffold/new_feature.sh')],
                                        env=dict(env, NAME=name, WIRE=wire, ROUTE_KIND=kind), capture_output=True, text=True)
                self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
                dto = root / f'features/{name}/{name}_data/lib/src/{name}_item_dto.dart'
                self.assertIn('@freezed', dto.read_text())
                self.assertNotIn('__name__', dto.read_text())
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
                self.assertNotIn('registerLazySingleton', source_di)
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

            # Fail before creating files if an app cannot be safely wired.
            app_di.write_text(app_di.read_text().replace('// scaffold:feature-registrations', ''))
            result = subprocess.run(['bash', str(root / 'tool/scaffold/new_feature.sh')],
                                    env=dict(env, NAME='invalid_wiring', WIRE='1'), capture_output=True, text=True)
            self.assertNotEqual(result.returncode, 0)
            self.assertFalse((root / 'features/invalid_wiring').exists())


if __name__ == '__main__':
    unittest.main()
