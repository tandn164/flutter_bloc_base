import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart' show GetItHelper;
import 'package:auth_domain/di/auth_domain_di.module.dart';
import 'package:app_result/app_result.dart';
import 'package:auth_domain/auth_domain.dart';
import 'package:test/test.dart';

class _Repo implements AuthRepository {
  @override
  Future<Result<TokenPair>> login(
      {required String email, required String password}) async {
    return const Ok(TokenPair(accessToken: 'a', refreshToken: 'r'));
  }

  @override
  Future<Result<TokenPair>> signup({
    required String email,
    required String password,
    required String name,
  }) async {
    return const Ok(TokenPair(accessToken: 'a', refreshToken: 'r'));
  }
}

void main() {
  test('package DI resolves use cases from supplied repository only', () async {
    final sl = GetIt.asNewInstance();
    final disabled = GetIt.asNewInstance();
    addTearDown(sl.reset);
    addTearDown(disabled.reset);
    sl.registerSingleton<AuthRepository>(_Repo());
    await AuthDomainPackageModule().init(GetItHelper(sl));
    expect(sl<LoginUseCase>(), same(sl<LoginUseCase>()));
    expect(disabled.isRegistered<LoginUseCase>(), isFalse);
    expect(sl<SignupUseCase>(), same(sl<SignupUseCase>()));
    expect(disabled.isRegistered<SignupUseCase>(), isFalse);
  });
  test('LoginUseCase returns tokens and does not own Session', () async {
    final repo = _Repo();
    final result = await LoginUseCase(repo).execute(
      email: 'a@b.c',
      password: 'x',
    );
    expect(result.valueOrNull?.accessToken, 'a');
    expect(result.valueOrNull?.refreshToken, 'r');
  });
}
