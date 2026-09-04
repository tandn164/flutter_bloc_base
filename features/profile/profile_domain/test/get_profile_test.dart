import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart' show GetItHelper;
import 'package:profile_domain/di/profile_domain_di.module.dart';
import 'package:app_result/app_result.dart';
import 'package:profile_domain/profile_domain.dart';
import 'package:test/test.dart';

class _Repo implements ProfileRepository {
  @override
  Future<Result<UserProfile>> me() async =>
      const Ok(UserProfile(id: '1', name: 'A', email: 'a@b.c'));

  @override
  Future<Result<UserProfile>> update({required String name}) async =>
      Ok(UserProfile(id: '1', name: name, email: 'a@b.c'));
}

void main() {
  test('package DI resolves use cases from supplied repository only', () async {
    final sl = GetIt.asNewInstance();
    final disabled = GetIt.asNewInstance();
    addTearDown(sl.reset);
    addTearDown(disabled.reset);
    sl.registerSingleton<ProfileRepository>(_Repo());
    await ProfileDomainPackageModule().init(GetItHelper(sl));
    expect(sl<GetProfile>(), same(sl<GetProfile>()));
    expect(disabled.isRegistered<GetProfile>(), isFalse);
    expect(sl<UpdateProfile>(), same(sl<UpdateProfile>()));
    expect(disabled.isRegistered<UpdateProfile>(), isFalse);
  });
  test('GetProfile returns repository profile', () async {
    final result = await GetProfile(_Repo()).execute();
    expect(result.valueOrNull?.name, 'A');
  });
}
