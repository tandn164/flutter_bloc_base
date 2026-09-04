"""Test actual shared scaffold entry points in isolated temporary workspaces."""
import os
from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest


class SharedPackageTest(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory()
        self.addCleanup(self.tmp.cleanup)
        self.root = Path(self.tmp.name)
        source = Path(__file__).resolve().parents[2]
        shutil.copytree(source / 'tool/scaffold', self.root / 'tool/scaffold')
        (self.root / 'shared').mkdir()
        (self.root / 'pubspec.yaml').write_text('name: fixture\nworkspace:\ndev_dependencies:\n  test: ^1.25.0\n')
        self.bin = self.root / 'bin'
        self.bin.mkdir()
        fvm = self.bin / 'fvm'
        fvm.write_text('#!/bin/sh\nexit 0\n')
        fvm.chmod(0o755)

    def run_script(self, mode, name='my_service', **options):
        env = dict(os.environ, PATH=f'{self.bin}:{os.environ["PATH"]}', NAME=name)
        env.pop('CONFIRM', None)
        env.pop('TYPE', None)
        env.update(options)
        return subprocess.run(['bash', str(self.root / f'tool/scaffold/{mode}_shared.sh')],
                              env=env, cwd=self.root, text=True, capture_output=True)

    def create(self, name='my_service', **options):
        result = self.run_script('new', name, **options)
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        return self.root / 'shared' / name

    def consumer(self, content, filename='pubspec.yaml'):
        app = self.root / 'apps/client'
        app.mkdir(parents=True, exist_ok=True)
        (app / filename).write_text(content)

    def test_create_both_types_and_workspace(self):
        for name, kind in [('my_service', 'dart'), ('my_widget', 'flutter')]:
            package = self.create(name, TYPE=kind)
            self.assertTrue((package / f'lib/{name}.dart').is_file())
            self.assertTrue((package / f'test/{name}_test.dart').is_file())
            self.assertEqual('sdk: flutter' in (package / 'pubspec.yaml').read_text(), kind == 'flutter')
            workspace = (self.root / 'pubspec.yaml').read_text()
            self.assertLess(workspace.index(f'  - shared/{name}'), workspace.index('dev_dependencies:'))

    def test_refuse_overwrite(self):
        package = self.create()
        (package / 'keep.txt').write_text('user content')
        self.assertNotEqual(self.run_script('new').returncode, 0)
        self.assertEqual((package / 'keep.txt').read_text(), 'user content')

    def test_invalid_name_type_and_duplicate_package_name(self):
        for name in ('../escape', 'bad-name', 'class', ''):
            self.assertNotEqual(self.run_script('new', name).returncode, 0)
        self.assertNotEqual(self.run_script('new', TYPE='invalid').returncode, 0)
        self.consumer('name: my_service\n')
        self.assertNotEqual(self.run_script('new').returncode, 0)

    def test_delete_needs_confirmation_and_keeps_backup(self):
        package = self.create()
        (package / 'keep.txt').write_text('recover me')
        self.assertNotEqual(self.run_script('delete').returncode, 0)
        self.assertTrue(package.exists())
        result = self.run_script('delete', CONFIRM='1')
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assertFalse(package.exists())
        backups = list((self.root / '.scaffold-trash').iterdir())
        self.assertEqual(len(backups), 1)
        self.assertEqual((backups[0] / 'keep.txt').read_text(), 'recover me')
        self.assertNotIn('  - shared/my_service', (self.root / 'pubspec.yaml').read_text())
        # Backups must not block reuse of the name or workspace discovery.
        self.create()

    def test_declared_dependents_block_delete(self):
        package = self.create()
        for section in ('dependencies', 'dev_dependencies', 'dependency_overrides'):
            for declaration in (f'{section}:\n  my_service: any\n', f'{section}: {{"my_service": any}}\n'):
                with self.subTest(declaration=declaration):
                    self.consumer('name: client\n' + declaration)
                    result = self.run_script('delete', CONFIRM='1')
                    self.assertNotEqual(result.returncode, 0)
                    self.assertIn('apps/client/pubspec.yaml', result.stderr)
                    self.assertTrue(package.exists())

    def test_path_reference_and_overrides_block_delete(self):
        self.create()
        self.consumer('dependency_overrides:\n  alias: {path: ../../shared/my_service}\n', 'pubspec_overrides.yaml')
        result = self.run_script('delete', CONFIRM='1')
        self.assertNotEqual(result.returncode, 0)
        self.assertIn('pubspec_overrides.yaml', result.stderr)

    def test_group_and_symlink_refused(self):
        group = self.root / 'shared/group'
        (group / 'child').mkdir(parents=True)
        (group / 'child/pubspec.yaml').write_text('name: child\n')
        self.assertNotEqual(self.run_script('delete', 'group', CONFIRM='1').returncode, 0)
        (self.root / 'shared/link').symlink_to(group, target_is_directory=True)
        self.assertNotEqual(self.run_script('new', 'link').returncode, 0)
        self.assertNotEqual(self.run_script('delete', 'link', CONFIRM='1').returncode, 0)
        self.assertTrue((group / 'child/pubspec.yaml').exists())

    def test_missing_package_is_noop(self):
        original = (self.root / 'pubspec.yaml').read_text()
        self.assertNotEqual(self.run_script('delete', CONFIRM='1').returncode, 0)
        self.assertEqual((self.root / 'pubspec.yaml').read_text(), original)


if __name__ == '__main__':
    unittest.main()
