import 'package:equatable/equatable.dart';

import 'auth_notice.dart';

class LoginState extends Equatable {
  const LoginState({this.busy = false, this.notice});

  final bool busy;
  final AuthNotice? notice;

  @override
  List<Object?> get props => [busy, notice];
}
