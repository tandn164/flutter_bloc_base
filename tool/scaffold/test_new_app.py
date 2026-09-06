import os
import pathlib
import shutil
import stat
import subprocess
import tempfile
import unittest


class NewAppTest(unittest.TestCase):
    def test_replaces_source_app_references_in_tests_and_source(self):
        source_root = pathlib.Path(__file__).resolve().parents[2]
        with tempfile.TemporaryDirectory() as directory:
            root = pathlib.Path(directory)
            scaffold = root / 'tool' / 'scaffold'
            scaffold.mkdir(parents=True)
            for filename in ('new_app.sh', 'common.sh', 'register_ide_app.sh'):
                shutil.copyfile(
                    source_root / 'tool' / 'scaffold' / filename,
                    scaffold / filename,
                )

            app = root / 'apps' / 'sample_app'
            (app / 'lib').mkdir(parents=True)
            (app / 'test').mkdir()
            (app / 'pubspec.yaml').write_text('name: sample_app\n')
            (app / 'lib' / 'main.dart').write_text(
                "import 'package:sample_app/app.dart';\n",
            )
            (app / 'test' / 'path_test.dart').write_text(
                "const appPath = 'apps/sample_app';\n",
            )
            (root / 'pubspec.yaml').write_text(
                'name: fixture\nworkspace:\n  - apps/sample_app\n',
            )

            bin_dir = root / 'bin'
            bin_dir.mkdir()
            fvm = bin_dir / 'fvm'
            fvm.write_text('#!/usr/bin/env bash\nexit 0\n')
            fvm.chmod(fvm.stat().st_mode | stat.S_IXUSR)

            subprocess.run(
                ['bash', str(scaffold / 'new_app.sh')],
                cwd=root,
                env={
                    **os.environ,
                    'PATH': f'{bin_dir}:{os.environ["PATH"]}',
                    'NAME': 'merchant_app',
                    'SOURCE': 'sample_app',
                },
                check=True,
                capture_output=True,
                text=True,
            )

            created = root / 'apps' / 'merchant_app'
            self.assertEqual(
                (created / 'pubspec.yaml').read_text(),
                'name: merchant_app\n',
            )
            self.assertIn(
                'package:merchant_app/',
                (created / 'lib' / 'main.dart').read_text(),
            )
            self.assertIn(
                'apps/merchant_app',
                (created / 'test' / 'path_test.dart').read_text(),
            )
            for path in created.rglob('*'):
                if path.is_file():
                    try:
                        text = path.read_text()
                    except UnicodeDecodeError:
                        continue
                    self.assertNotIn('sample_app', text, str(path))


if __name__ == '__main__':
    unittest.main()
