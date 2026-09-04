import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart' show GetItHelper;
import 'package:profile_data/di/profile_data_di.module.dart';
import 'package:profile_domain/profile_domain.dart';
import 'package:api_client/api_client.dart';
import 'package:app_result/app_result.dart';
import 'package:chopper/chopper.dart';
import 'package:profile_data/profile_data.dart';
import 'package:test/test.dart';

class _Transport implements ApiTransport {
  @override
  int get httpCount => 1;

  @override
  Future<ApiResponse> send(ApiRequest request) async {
    expect(request.path, ProfileApi.mePath);
    return const ApiResponse(
      statusCode: 200,
      body: '{"id":"1","name":"A","email":"a@b.c"}',
    );
  }
}

void main() {
  test('remote module wires API, datasource and repository', () async {
    final sl = GetIt.asNewInstance();
    final transport = _Transport();
    final client = ChopperClient(
      baseUrl: Uri.parse('http://local'),
      client: ApiHttpClient(ApiClient(transport: transport)),
      converter: const JsonConverter(),
      errorConverter: const JsonConverter(),
    );
    addTearDown(client.dispose);
    addTearDown(sl.reset);
    sl.registerSingleton<ChopperClient>(client);
    await ProfileDataPackageModule()
        .init(GetItHelper(sl, 'remote'));
    final repository = sl<ProfileRepository>();
    expect(repository, same(sl<ProfileRepository>()));
    final result = await repository.me();
    expect(result, isA<Ok>());
  });

  test('custom environment does not install remote providers', () async {
    final sl = GetIt.asNewInstance();
    addTearDown(sl.reset);
    await ProfileDataPackageModule()
        .init(GetItHelper(sl, 'custom'));
    expect(sl.isRegistered<ProfileRepository>(), isFalse);
    expect(sl.isRegistered<ProfileApi>(), isFalse);
  });
  test('ProfileRepositoryImpl me goes through ProfileApi', () async {
    final client = ApiClient(transport: _Transport());
    final chopper = ChopperClient(
      baseUrl: Uri.parse('http://local'),
      client: ApiHttpClient(client),
      converter: const JsonConverter(),
      errorConverter: const JsonConverter(),
      services: [ProfileApi.create()],
    );
    try {
      final repo = ProfileRepositoryImpl(chopper.getService<ProfileApi>());
      final result = await repo.me();
      expect(result, isA<Ok>());
      expect(result.valueOrNull?.name, 'A');
    } finally {
      chopper.dispose();
    }
  });
}
