import 'package:equatable/equatable.dart';
import 'package:flutter_bloc_base/screens/login/domain/entities/login.dart';
import 'package:meta/meta.dart';

@immutable
abstract class UserLoginState extends Equatable {
  const UserLoginState([List props = const <dynamic>[]]) : super();
}

class NotLoggedState extends UserLoginState {
  @override
  List<Object?> get props => [];
}

class LoadingState extends UserLoginState {
  @override
  List<Object?> get props => [];
}

class LoggedState extends UserLoginState {
  final Login login;

  LoggedState({required this.login}) : super([login]);

  @override
  List<Object?> get props => [login];
}

class ErrorState extends UserLoginState {
  final String message;

  ErrorState({required this.message}) : super([message]);

  @override
  List<Object?> get props => [message];
}
