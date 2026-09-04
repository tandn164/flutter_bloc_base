import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart' show GetItHelper;
import 'package:auth_data/di/auth_data_di.module.dart';
import 'package:app_session/app_session.dart';
import 'package:api_client/api_client.dart';
import 'package:app_result/app_result.dart';
import 'package:auth_data/auth_data.dart';
import 'package:auth_domain/auth_domain.dart';
import 'package:chopper/chopper.dart';
import 'package:flutter_test/flutter_test.dart';

class _LoginTransport implements ApiTransport {
  @override
  int get httpCount => 1;

  @override
  Future<ApiResponse> send(ApiRequest request) async {
    expect(request.path, AuthApi.loginPath);
    expect(request.method, 'POST');
    return const ApiResponse(
      statusCode: 200,
      body: '{"accessToken":"a","refreshToken":"r"}',
    );
  }
}

void main() {
  test('remote module wires API, datasource and repository', () async {
    final sl = GetIt.asNewInstance();
    final transport = _LoginTransport();
    final client = ChopperClient(
      baseUrl: Uri.parse('http://local'),
      client: ApiHttpClient(ApiClient(transport: transport)),
      converter: const JsonConverter(),
      errorConverter: const JsonConverter(),
    );
    addTearDown(client.dispose);
    addTearDown(sl.reset);
    sl.registerSingleton<ChopperClient>(client);
    sl.registerSingleton<ApiTransport>(transport);
    sl.registerSingleton<TokenVault>(MemoryTokenVault());
    sl.registerSingleton<AuthSessionConfig>(const AuthSessionConfig(
        guestAllowed: false, restoreDelay: Duration.zero));
    await AuthDataPackageModule().init(GetItHelper(sl, 'remote'));
    final repository = sl<AuthRepository>();
    expect(repository, same(sl<AuthRepository>()));
    final result = await repository.login(email: 'a@b.c', password: 'x');
    expect(result, isA<Ok>());
    final session = sl<Session>();
    await session.restore();
    expect(session.state.status, SessionStatus.unauthenticated);
    await sl.reset();
    expect(
        () => (session as AuthSession).addListener(() {}), throwsFlutterError);
  });

  test('custom environment does not install remote providers', () async {
    final sl = GetIt.asNewInstance();
    addTearDown(sl.reset);
    await AuthDataPackageModule().init(GetItHelper(sl, 'custom'));
    expect(sl.isRegistered<AuthRepository>(), isFalse);
    expect(sl.isRegistered<AuthApi>(), isFalse);
  });
  test('AuthRepositoryImpl login goes through AuthApi path once', () async {
    final client = ApiClient(transport: _LoginTransport());
    final chopper = ChopperClient(
      baseUrl: Uri.parse('http://local'),
      client: ApiHttpClient(client),
      converter: const JsonConverter(),
      errorConverter: const JsonConverter(),
      services: [AuthApi.create()],
    );
    try {
      final repo = AuthRepositoryImpl(chopper.getService<AuthApi>());
      final result = await repo.login(email: 'a@b.c', password: 'x');
      expect(result, isA<Ok<TokenPair>>());
      expect(result.valueOrNull?.accessToken, 'a');
    } finally {
      chopper.dispose();
    }
  });
}
