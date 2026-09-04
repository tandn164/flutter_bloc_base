import 'package:app_result/app_result.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart' show GetItHelper;
import 'package:profile_domain/profile_domain.dart';
import 'package:profile_domain/di/profile_domain_di.module.dart';
import 'package:profile_presentation/profile_presentation.dart';
import 'package:profile_presentation/di/profile_presentation_di.module.dart';

class _Repository implements ProfileRepository {
  @override
  Future<Result<UserProfile>> me() async =>
      const Ok(UserProfile(id: '1', name: 'A', email: 'a@b.c'));
  @override
  Future<Result<UserProfile>> update({required String name}) async =>
      Ok(UserProfile(id: '1', name: name, email: 'a@b.c'));
}

void main() {
  test('package BLoC factory receives per-instance sign-out callback',
      () async {
    final sl = GetIt.asNewInstance();
    addTearDown(sl.reset);
    sl.registerSingleton<ProfileRepository>(_Repository());
    await ProfileDomainPackageModule().init(GetItHelper(sl));
    await ProfilePresentationPackageModule().init(GetItHelper(sl));
    var calls = 0;
    Future<void> signOut() async {
      calls++;
    }

    final first = sl<ProfileBloc>(param1: signOut);
    final second = sl<ProfileBloc>(param1: signOut);
    addTearDown(first.close);
    addTearDown(second.close);
    expect(first, isNot(same(second)));
    first.add(const ProfileStarted());
    await pumpEventQueue();
    expect(first.state, isA<ProfileData>());
    first.add(const ProfileSignedOut());
    await pumpEventQueue();
    expect(calls, 1);
  });
}
