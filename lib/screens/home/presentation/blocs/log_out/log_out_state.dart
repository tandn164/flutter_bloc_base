import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class LogOutState extends Equatable {
  const LogOutState([List props = const <dynamic>[]]) : super();
}

class LoggedInState extends LogOutState {
  @override
  List<Object?> get props => [];
}

class LoggedOutState extends LogOutState {
  @override
  List<Object?> get props => [];
}

class LoadingState extends LogOutState {
  @override
  List<Object?> get props => [];
}

class ErrorState extends LogOutState {
  final String message;

  const ErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
