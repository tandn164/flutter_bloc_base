import 'package:injectable/injectable.dart';
import '../auth_callbacks.dart';
import 'package:auth_domain/auth_domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'auth_notice.dart';
import 'login_event.dart';
import 'login_state.dart';

export 'auth_notice.dart';
export 'login_event.dart';
export 'login_state.dart';

@injectable
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc({
    required LoginUseCase login,
    @factoryParam required OnAuthenticated onAuthenticated,
  })  : _login = login,
        _onAuthenticated = onAuthenticated,
        super(const LoginState()) {
    on<LoginSubmitted>(_onSubmit);
  }

  final LoginUseCase _login;
  final Future<void> Function(TokenPair tokens) _onAuthenticated;
  int _noticeId = 0;

  Future<void> _onSubmit(LoginSubmitted event, Emitter<LoginState> emit) async {
    emit(const LoginState(busy: true));
    try {
      final result = await _login.execute(
        email: event.email,
        password: event.password,
      );
      await result.fold<Future<void>>(
        ok: (tokens) async {
          await _onAuthenticated(tokens);
          emit(LoginState(
            notice: AuthNotice(
              message: 'Signed in',
              kind: AuthNoticeKind.success,
              id: ++_noticeId,
            ),
          ));
        },
        err: (f) async {
          emit(LoginState(
            notice: AuthNotice(
              message: f.message,
              kind: AuthNoticeKind.error,
              id: ++_noticeId,
            ),
          ));
        },
      );
    } catch (e) {
      emit(LoginState(
        notice: AuthNotice(
          message: e.toString(),
          kind: AuthNoticeKind.error,
          id: ++_noticeId,
        ),
      ));
    }
  }
}
