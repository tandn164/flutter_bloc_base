import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc_base/core/error/failures.dart';
import 'package:flutter_bloc_base/core/usecases/usecase.dart';
import 'package:flutter_bloc_base/screens/login/domain/entities/login.dart';
import 'package:flutter_bloc_base/screens/login/domain/repositories/login_repository.dart';

class LoginUser implements UseCase<Login, LoginParams> {
  final LoginRepository repository;

  LoginUser({required this.repository});

  @override
  Future<Either<Failure, Login>> call(LoginParams params) async {
    return await repository.loginUser(params.email, params.password);
  }
}

class LoginParams extends Equatable {
  final String email;
  final String password;

  const LoginParams({required this.email, required this.password})
      : super();

  @override
  List<Object?> get props => [email, password];
}
