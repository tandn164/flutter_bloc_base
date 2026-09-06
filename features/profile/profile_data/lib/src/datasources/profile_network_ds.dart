import 'package:injectable/injectable.dart';
import 'package:api_client/api_client.dart';
import 'package:app_result/app_result.dart';

import '../api/profile_api.dart';
import '../dtos/user_profile_dto.dart';

@LazySingleton()
class ProfileNetworkDs {
  ProfileNetworkDs(this._api);

  final ProfileApi _api;

  Future<Result<UserProfileDto>> me() async {
    return chopperResult(
      _api.me,
      (json) => UserProfileDto.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<Result<UserProfileDto>> updateMe({required String name}) async {
    return chopperResult(
      () => _api.updateMe(
        {'name': name},
      ),
      (json) => UserProfileDto.fromJson(json as Map<String, dynamic>),
    );
  }
}
