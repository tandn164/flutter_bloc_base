import 'package:injectable/injectable.dart';
import 'package:app_result/app_result.dart';
import 'package:profile_domain/profile_domain.dart';

import '../api/profile_api.dart';
import '../datasources/profile_network_ds.dart';

@LazySingleton(as: ProfileRepository, env: ['remote'])
class ProfileRepositoryImpl implements ProfileRepository {
  ProfileRepositoryImpl(ProfileApi api) : _network = ProfileNetworkDs(api);

  @factoryMethod
  ProfileRepositoryImpl.fromNetwork(this._network);

  final ProfileNetworkDs _network;

  @override
  Future<Result<UserProfile>> me() async {
    final result = await _network.me();
    return result.fold(
      ok: (dto) => Ok(dto.toEntity()),
      err: (failure) => Err(failure),
    );
  }

  @override
  Future<Result<UserProfile>> update({required String name}) async {
    final result = await _network.updateMe(name: name);
    return result.fold(
      ok: (dto) => Ok(dto.toEntity()),
      err: (failure) => Err(failure),
    );
  }
}
