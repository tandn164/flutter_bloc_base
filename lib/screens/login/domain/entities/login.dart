import 'package:equatable/equatable.dart';

class Login extends Equatable {
  final String token;

  const Login({required this.token}) : super();

  @override
  List<Object?> get props => [token];
}
