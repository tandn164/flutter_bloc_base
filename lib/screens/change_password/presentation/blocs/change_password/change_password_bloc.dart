import 'package:bloc/bloc.dart';
import 'package:flutter_bloc_base/core/utils/constants.dart';
import 'package:flutter_bloc_base/screens/change_password/domain/usecases/change_password.dart';

import 'bloc.dart';

class ChangePasswordBloc
    extends Bloc<ChangePasswordEvent, ChangePasswordState> {
  final ChangePassword changePassword;

  ChangePasswordBloc({required this.changePassword}) : super(InitialState()) {
    on<PasswordChangeEvent>(_onChangePassword);
  }

  _onChangePassword(PasswordChangeEvent event, Emitter<ChangePasswordState> emit) async* {
    emit(LoadingState());
    final result = await changePassword(ChangePasswordParams(
      oldPassword: event.oldPassword,
      newPassword: event.newPassword,
    ));
    yield* result.fold((failure) async* {
      emit(const ErrorState(CHANGE_PASSWORD_ERROR));
    }, (success) async* {
      emit(SuccessfulState());
    });
  }
}
