import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc_base/core/error/failures.dart';
import 'package:flutter_bloc_base/core/usecases/usecase.dart';
import 'package:flutter_bloc_base/screens/home/domain/repositories/home_repository.dart';

class LogOutUser implements UseCase<bool, LogOutParams> {
  final HomeRepository repository;

  LogOutUser({required this.repository});

  @override
  Future<Either<Failure, bool>> call(LogOutParams params) async {
    return await repository.logoutUser(params.token);
  }
}

class LogOutParams extends Equatable {
  final String token;
  const LogOutParams({required this.token}) : super();

  @override
  List<Object?> get props => [token];
}
