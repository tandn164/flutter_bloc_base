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
  test('package module wires concrete API, datasource and repository',
      () async {
    final sl = GetIt.asNewInstance();
    final transport = _Transport();
    final client = ChopperClient(
      baseUrl: Uri.parse('http://local'),
      client: ChopperApiTransportAdapter(ApiClient(transport: transport)),
      converter: const JsonConverter(),
      errorConverter: const JsonConverter(),
    );
    addTearDown(client.dispose);
    addTearDown(sl.reset);
    sl.registerSingleton<ChopperClient>(client);
    await ProfileDataPackageModule().init(GetItHelper(sl));
    final repository = sl<ProfileRepositoryImpl>();
    expect(repository, same(sl<ProfileRepositoryImpl>()));
    final result = await repository.me();
    expect(result, isA<Ok>());
  });

  test('package module leaves product contracts for app binding', () async {
    final sl = GetIt.asNewInstance();
    addTearDown(sl.reset);
    await ProfileDataPackageModule().init(GetItHelper(sl));
    expect(sl.isRegistered<ProfileRepository>(), isFalse);
    expect(sl.isRegistered<ProfileRepositoryImpl>(), isTrue);
    expect(sl.isRegistered<ProfileApi>(), isTrue);
  });
  test('ProfileRepositoryImpl me goes through ProfileApi', () async {
    final client = ApiClient(transport: _Transport());
    final chopper = ChopperClient(
      baseUrl: Uri.parse('http://local'),
      client: ChopperApiTransportAdapter(client),
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
