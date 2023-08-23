import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class LogOutEvent extends Equatable {
  const LogOutEvent([List props = const <dynamic>[]]) : super();
}

class UserLogOutEvent extends LogOutEvent {
  @override
  List<Object?> get props => [];
}
