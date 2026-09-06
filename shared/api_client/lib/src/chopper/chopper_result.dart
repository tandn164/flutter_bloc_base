import 'package:app_result/app_result.dart';
import 'package:chopper/chopper.dart';

import '../decoding/safe_decode.dart';

/// Executes a generated endpoint and maps transport/status/decode failures.
Future<Result<T>> chopperResult<T>(
  Future<Response<dynamic>> Function() call,
  T Function(Object json) decode,
) async {
  try {
    final response = await call();
    if (response.statusCode == 401) return const Err(AuthFailure());
    if (!response.isSuccessful) {
      return Err(ServerFailure('HTTP ${response.statusCode}'));
    }
    return safeDecode(response.bodyString, decode);
  } catch (_) {
    return const Err(NetworkFailure());
  }
}
