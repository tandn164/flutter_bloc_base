import 'package:api_client/api_client.dart';
import 'package:app_result/app_result.dart';
import 'package:test/test.dart';

class _Transport implements ApiTransport {
  _Transport(this.response);

  final ApiResponse response;
  ApiRequest? lastRequest;

  @override
  int get httpCount => lastRequest == null ? 0 : 1;

  @override
  Future<ApiResponse> send(ApiRequest request) async {
    lastRequest = request;
    return response;
  }
}

class _HeaderInterceptor implements ApiInterceptor {
  @override
  Future<ApiResponse> intercept(ApiRequest request, ApiHandler next) {
    return next(
      request.copyWith(headers: {...request.headers, 'x-test': 'true'}),
    );
  }
}

void main() {
  test('ApiClient applies low-level interceptors before transport', () async {
    final transport = _Transport(
      const ApiResponse(statusCode: 200, body: '{}'),
    );
    final client = ApiClient(
      transport: transport,
      interceptors: [_HeaderInterceptor()],
    );

    await client.send(const ApiRequest(method: 'GET', path: '/profile'));

    expect(transport.lastRequest?.headers['x-test'], 'true');
  });

  test('sendDecoded maps malformed response to DecodeFailure', () async {
    final client = ApiClient(
      transport: _Transport(
        const ApiResponse(statusCode: 200, body: 'not-json'),
      ),
    );

    final result = await client.sendDecoded<String>(
      request: const ApiRequest(method: 'GET', path: '/profile'),
      decode: (json) => (json as Map<String, dynamic>)['name'] as String,
    );

    expect(result.failureOrNull, isA<DecodeFailure>());
  });
}
