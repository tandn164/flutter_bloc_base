import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class UserLoginEvent extends Equatable {
  const UserLoginEvent([List props = const <dynamic>[]]) : super();
}

class CheckLoginStatusEvent extends UserLoginEvent {
  @override
  List<Object?> get props => [];
}

class LoginEvent extends UserLoginEvent {
  final String email;
  final String password;

  const LoginEvent(this.email, this.password);

  @override
  List<Object?> get props => [email, password];
}

class SkipLoginEvent extends UserLoginEvent {
  @override
  List<Object?> get props => [];
}
