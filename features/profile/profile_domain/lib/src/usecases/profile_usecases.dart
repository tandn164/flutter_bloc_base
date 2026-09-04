import 'package:injectable/injectable.dart';
import 'package:app_result/app_result.dart';

import '../entities/user_profile.dart';
import '../repositories/profile_repository.dart';

@lazySingleton
class GetProfile {
  GetProfile(this._repository);

  final ProfileRepository _repository;

  Future<Result<UserProfile>> execute() => _repository.me();
}

@lazySingleton
class UpdateProfile {
  UpdateProfile(this._repository);

  final ProfileRepository _repository;

  Future<Result<UserProfile>> execute({required String name}) {
    return _repository.update(name: name);
  }
}
