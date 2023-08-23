import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class ChangePasswordEvent extends Equatable {
  const ChangePasswordEvent([List props = const <dynamic>[]]) : super();
}

class PasswordChangeEvent extends ChangePasswordEvent {
  final String oldPassword;
  final String newPassword;

  const PasswordChangeEvent({required this.oldPassword, required this.newPassword});

  @override
  List<Object?> get props => [oldPassword, newPassword];
}