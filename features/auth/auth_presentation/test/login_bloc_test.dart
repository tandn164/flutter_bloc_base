import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart' show GetItHelper;
import 'package:auth_domain/di/auth_domain_di.module.dart';
import 'package:auth_presentation/di/auth_presentation_di.module.dart';
import 'package:app_result/app_result.dart';
import 'package:auth_domain/auth_domain.dart';
import 'package:auth_presentation/auth_presentation.dart';
import 'package:flutter_test/flutter_test.dart';

class _Repo implements AuthRepository {
  _Repo(this.result);
  Result<TokenPair> result;

  @override
  Future<Result<TokenPair>> login(
          {required String email, required String password}) async =>
      result;

  @override
  Future<Result<TokenPair>> signup({
    required String email,
    required String password,
    required String name,
  }) async =>
      result;
}

void main() {
  test('package factories use per-instance authentication callbacks', () async {
    final sl = GetIt.asNewInstance();
    addTearDown(sl.reset);
    sl.registerSingleton<AuthRepository>(
        _Repo(const Ok(TokenPair(accessToken: 'a', refreshToken: 'r'))));
    await AuthDomainPackageModule().init(GetItHelper(sl));
    await AuthPresentationPackageModule().init(GetItHelper(sl));
    var firstCalls = 0;
    var secondCalls = 0;
    Future<void> firstCallback(TokenPair _) async {
      firstCalls++;
    }

    Future<void> secondCallback(TokenPair _) async {
      secondCalls++;
    }

    final first = sl<LoginBloc>(param1: firstCallback);
    final second = sl<LoginBloc>(param1: secondCallback);
    final signup = sl<SignupBloc>(param1: secondCallback);
    addTearDown(first.close);
    addTearDown(second.close);
    addTearDown(signup.close);
    expect(first, isNot(same(second)));
    first.add(const LoginSubmitted(email: 'a@b.c', password: 'x'));
    await pumpEventQueue();
    expect(firstCalls, 1);
    expect(secondCalls, 0);
    signup.add(const SignupSubmitted(email: 'a@b.c', password: 'x', name: 'A'));
    await pumpEventQueue();
    expect(secondCalls, 1);
  });
  test('LoginBloc calls onAuthenticated with tokens from UseCase', () async {
    TokenPair? received;
    final bloc = LoginBloc(
      login: LoginUseCase(
        _Repo(const Ok(TokenPair(accessToken: 'a', refreshToken: 'r'))),
      ),
      onAuthenticated: (tokens) async => received = tokens,
    );

    bloc.add(const LoginSubmitted(email: 'a@b.c', password: 'x'));
    await pumpEventQueue();

    expect(received?.accessToken, 'a');
    expect(received?.refreshToken, 'r');
    expect(bloc.state.busy, isFalse);
    expect(bloc.state.notice?.message, 'Signed in');
    expect(bloc.state.notice?.kind, AuthNoticeKind.success);
    await bloc.close();
  });

  test('LoginBloc does not authenticate on failure; busy is cleared', () async {
    var authenticated = false;
    final bloc = LoginBloc(
      login: LoginUseCase(_Repo(const Err(AuthFailure('bad')))),
      onAuthenticated: (_) async => authenticated = true,
    );

    bloc.add(const LoginSubmitted(email: 'a@b.c', password: 'x'));
    await pumpEventQueue();

    expect(authenticated, isFalse);
    expect(bloc.state.busy, isFalse);
    expect(bloc.state.notice?.message, 'bad');
    expect(bloc.state.notice?.kind, AuthNoticeKind.error);
    await bloc.close();
  });
}
