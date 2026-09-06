import 'package:api_client/api_client.dart';
import 'package:chopper/chopper.dart';
import 'package:app_result/app_result.dart';
import 'package:sample_data/sample_data.dart';
import 'package:sample_data/di/sample_data_di.module.dart';
import 'package:sample_domain/sample_domain.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart' show GetItHelper;
import 'package:test/test.dart';

class _CountingTransport implements ApiTransport {
  int calls = 0;
  String body = '{"items":[{"id":"1","title":"A"}]}';
  ApiRequest? lastRequest;

  @override
  int get httpCount => calls;

  @override
  Future<ApiResponse> send(ApiRequest request) async {
    calls++;
    lastRequest = request;
    return ApiResponse(statusCode: 200, body: body);
  }
}

void main() {
  late _CountingTransport transport;
  late SampleRepositoryImpl repo;
  late ChopperClient chopper;

  setUp(() {
    transport = _CountingTransport();
    final client = ApiClient(transport: transport);
    chopper = ChopperClient(
      baseUrl: Uri.parse('http://local'),
      client: ChopperApiTransportAdapter(client),
      converter: const JsonConverter(),
      errorConverter: const JsonConverter(),
      services: [SampleApi.create()],
    );
    addTearDown(chopper.dispose);
    repo = SampleRepositoryImpl(api: chopper.getService<SampleApi>());
  });

  test('maps a generated Chopper response', () async {
    final result = await repo.getSample();
    expect(result, isA<Ok>());
    expect(result.valueOrNull?.items.single.title, 'A');
    expect(transport.calls, 1);
  });

  test('package DI exposes concrete repositories for app selection', () async {
    final sl = GetIt.asNewInstance();
    addTearDown(sl.reset);
    sl.registerSingleton<ChopperClient>(chopper);
    await SampleDataPackageModule().init(GetItHelper(sl));
    expect(sl.isRegistered<SampleRepository>(), isFalse);
    expect(sl<LocalSampleRepository>(), isA<LocalSampleRepository>());
    final result = await sl<SampleRepositoryImpl>().getSample();
    expect(result.valueOrNull?.items.single.title, 'A');
    expect(transport.calls, 1);
  });

  test('does not hide caching in the HTTP layer', () async {
    await repo.getSample();
    await repo.getSample();
    expect(transport.calls, 2);
  });

  test('generated mutation calls transport directly', () async {
    transport.body = '{"id":"2","title":"Created"}';
    final result = await repo.createItem(title: 'Created');
    expect(result, isA<Ok<SampleItem>>());
    expect(transport.lastRequest?.method, 'POST');
  });
}
