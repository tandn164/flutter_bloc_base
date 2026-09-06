import 'package:injectable/injectable.dart';
import '../auth_callbacks.dart';
import 'package:auth_domain/auth_domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'auth_notice.dart';
import 'signup_event.dart';
import 'signup_state.dart';

export 'auth_notice.dart';
export 'signup_event.dart';
export 'signup_state.dart';

@injectable
class SignupBloc extends Bloc<SignupEvent, SignupState> {
  SignupBloc({
    required SignupUseCase signup,
    @factoryParam required OnAuthenticated onAuthenticated,
  })  : _signup = signup,
        _onAuthenticated = onAuthenticated,
        super(const SignupState()) {
    on<SignupSubmitted>(_onSubmit);
  }

  final SignupUseCase _signup;
  final Future<void> Function(TokenPair tokens) _onAuthenticated;
  int _noticeId = 0;

  Future<void> _onSubmit(
      SignupSubmitted event, Emitter<SignupState> emit) async {
    emit(const SignupState(busy: true));
    try {
      final result = await _signup.execute(
        email: event.email,
        password: event.password,
        name: event.name,
      );
      await result.fold<Future<void>>(
        ok: (tokens) async {
          await _onAuthenticated(tokens);
          emit(SignupState(
            notice: AuthNotice(
              message: 'Account created',
              kind: AuthNoticeKind.success,
              id: ++_noticeId,
            ),
          ));
        },
        err: (f) async {
          emit(SignupState(
            notice: AuthNotice(
              message: f.message,
              kind: AuthNoticeKind.error,
              id: ++_noticeId,
            ),
          ));
        },
      );
    } catch (e) {
      emit(SignupState(
        notice: AuthNotice(
          message: e.toString(),
          kind: AuthNoticeKind.error,
          id: ++_noticeId,
        ),
      ));
    }
  }
}
