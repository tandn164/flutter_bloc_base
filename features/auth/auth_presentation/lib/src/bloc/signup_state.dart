import 'package:equatable/equatable.dart';

import 'auth_notice.dart';

class SignupState extends Equatable {
  const SignupState({this.busy = false, this.notice});

  final bool busy;
  final AuthNotice? notice;

  @override
  List<Object?> get props => [busy, notice];
}
