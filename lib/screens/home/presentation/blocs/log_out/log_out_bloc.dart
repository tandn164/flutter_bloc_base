import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_bloc_base/core/usecases/fetch_token.dart';
import 'package:flutter_bloc_base/core/utils/constants.dart';
import 'package:flutter_bloc_base/screens/home/domain/usecases/logout_user.dart';

import 'bloc.dart';

class LogOutBloc extends Bloc<LogOutEvent, LogOutState> {
  final FetchToken fetchToken;
  final LogOutUser logoutUser;

  LogOutBloc({required this.fetchToken, required this.logoutUser}) : super(LoggedInState()) {
    on<UserLogOutEvent>(_onUserLogOut);
  }

  _onUserLogOut(UserLogOutEvent event, Emitter<LogOutState> emit) async {
    emit(LoadingState());
    final token = await fetchToken(TokenParams());
    token.fold((l) => emit(LoggedOutState()),
            (r) async {
        final result = await logoutUser(LogOutParams(token: r.token));
        result.fold((l) => emit(const ErrorState(LOGGING_OUT_ERROR)),
                (r) => emit(LoggedOutState()));
            });
  }
}
