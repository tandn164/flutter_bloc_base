import 'package:injectable/injectable.dart';
import 'package:api_client/api_client.dart';
import 'package:app_result/app_result.dart';

import '../api/auth_api.dart';
import '../dtos/token_pair_dto.dart';

@LazySingleton()
class AuthNetworkDs {
  AuthNetworkDs(this._api);

  final AuthApi _api;

  Future<Result<TokenPairDto>> login({
    required String email,
    required String password,
  }) async {
    return chopperResult(
      () => _api.login(
        {'email': email, 'password': password},
      ),
      (json) => TokenPairDto.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<Result<TokenPairDto>> signup({
    required String email,
    required String password,
    required String name,
  }) async {
    return chopperResult(
      () => _api.signup(
        {'email': email, 'password': password, 'name': name},
      ),
      (json) => TokenPairDto.fromJson(json as Map<String, dynamic>),
    );
  }
}
