import 'package:injectable/injectable.dart';
import 'package:chopper/chopper.dart';

part 'profile_api.chopper.dart';

@LazySingleton()
@ChopperApi()
abstract class ProfileApi extends ChopperService {
  static const mePath = '/demo/me';

  static ProfileApi create([ChopperClient? client]) => _$ProfileApi(client);

  @factoryMethod
  static ProfileApi createForDi(ChopperClient client) => create(client);

  @GET(path: mePath)
  Future<Response<dynamic>> me();

  @PATCH(path: mePath)
  Future<Response<dynamic>> updateMe(
    @Body() Map<String, dynamic> body,
  );
}
