"""Regression test for adopting a copied base without self-modifying scripts."""

import os
from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest


class AdoptProjectTest(unittest.TestCase):
    def test_rename_completes_while_renaming_its_own_source_text(self):
        source = Path(__file__).resolve().parents[2]
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            (root / 'tool/scaffold').mkdir(parents=True)
            for relative in (
                'tool/adopt_project.sh',
                'tool/rename_project_slug.sh',
                'tool/scaffold/common.sh',
            ):
                target = root / relative
                target.parent.mkdir(parents=True, exist_ok=True)
                shutil.copyfile(source / relative, target)

            (root / 'pubspec.yaml').write_text(
                'name: flutter_ffca_base_workspace\n',
            )
            kotlin = root / (
                'apps/demo/android/app/src/main/kotlin/com/company/'
                'flutter_ffca_base'
            )
            kotlin.mkdir(parents=True)
            (kotlin / 'MainActivity.kt').write_text(
                'package com.company.flutter_ffca_base\n',
            )
            (root / 'flutter_ffca_base.iml').write_text(
                '<module>flutter_ffca_base</module>\n',
            )

            binary = root / 'bin'
            binary.mkdir()
            fvm = binary / 'fvm'
            fvm.write_text('#!/bin/sh\nexit 0\n')
            fvm.chmod(0o755)

            result = subprocess.run(
                ['bash', str(root / 'tool/adopt_project.sh')],
                cwd=root,
                env=dict(
                    os.environ,
                    PATH=f'{binary}:{os.environ["PATH"]}',
                    PACKAGE='futizen_app',
                    TITLE='Futizen Memory',
                    CONFIRM='1',
                ),
                capture_output=True,
                text=True,
            )

            self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
            self.assertIn('name: futizen_app_workspace',
                          (root / 'pubspec.yaml').read_text())
            self.assertTrue((root / 'futizen_app.iml').exists())
            moved = root / 'apps/demo/android/app/src/main/kotlin/com/company/futizen_app'
            self.assertTrue(moved.exists())
            self.assertIn('package com.company.futizen_app',
                          (moved / 'MainActivity.kt').read_text())


if __name__ == '__main__':
    unittest.main()
