import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_bloc_base/core/error/failures.dart';
import 'package:flutter_bloc_base/core/utils/constants.dart';
import 'package:flutter_bloc_base/screens/login/domain/entities/login.dart';
import 'package:flutter_bloc_base/core/usecases/fetch_token.dart';
import 'package:flutter_bloc_base/screens/login/domain/usecases/login_user.dart';
import 'bloc.dart';

class UserLoginBloc extends Bloc<UserLoginEvent, UserLoginState> {
  final LoginUser loginUser;
  final FetchToken fetchToken;

  UserLoginBloc({required this.loginUser,
    required this.fetchToken}) : super(NotLoggedState()) {
    on<CheckLoginStatusEvent>(_onCheckLoginStatus);
    on<LoginEvent>(_onLogin);
    on<SkipLoginEvent>(_onSkipLogin);
  }

  _onCheckLoginStatus(CheckLoginStatusEvent event, Emitter<UserLoginState> emit) async {
    emit(LoadingState());
    var result = await fetchToken(TokenParams());
    result.fold(
            (l) => emit(NotLoggedState()),
            (r) => emit(LoggedState(login: Login(token: r.token))));
  }

  _onLogin(LoginEvent event, Emitter<UserLoginState> emit) async {
    emit(LoadingState());
    var result = await loginUser(
        LoginParams(email: event.email, password: event.password));
    result.fold(
            (l) => {
            if (l is NoConnectionFailure) {
        emit(ErrorState(message: NO_CONNECTION_ERROR))
            } else {
        emit(ErrorState(message: LOGGING_ERROR))
            }},
            (r) => emit(LoggedState(login: Login(token: r.token))));
  }

  _onSkipLogin(SkipLoginEvent event, Emitter<UserLoginState> emit) async {
    emit(LoggedState(login: const Login(token: "111111111111111111111111")));
  }
}
