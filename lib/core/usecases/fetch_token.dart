import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc_base/core/error/failures.dart';
import 'package:flutter_bloc_base/core/usecases/usecase.dart';
import 'package:flutter_bloc_base/screens/login/domain/entities/login.dart';
import 'package:flutter_bloc_base/screens/login/domain/repositories/login_repository.dart';

class FetchToken implements UseCase<Login, TokenParams> {
  final LoginRepository repository;

  FetchToken({required this.repository});

  @override
  Future<Either<Failure, Login>> call(TokenParams params) async {
    return await repository.fetchCachedToken();
  }
}

class TokenParams extends Equatable {
  @override
  List<Object?> get props => [];
}