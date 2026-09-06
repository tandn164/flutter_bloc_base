import 'dart:async';

import 'package:offline_sync/offline_sync.dart';
import 'package:test/test.dart';

class _Task implements SyncTask {
  _Task(this._callback);
  final Future<void> Function() _callback;
  @override
  final String key = 'sample';
  @override
  Future<void> execute() => _callback();
}

void main() {
  test('coalesces concurrent runs of the same task', () async {
    final runner = FeatureSyncRunner();
    final gate = Completer<void>();
    var calls = 0;
    final task = _Task(() async {
      calls++;
      await gate.future;
    });

    final first = runner.run(task);
    final second = runner.run(task);
    gate.complete();
    await Future.wait([first, second]);

    expect(calls, 1);
    await runner.dispose();
  });
}
