import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc_base/core/error/failures.dart';
import 'package:flutter_bloc_base/core/usecases/usecase.dart';
import 'package:flutter_bloc_base/screens/change_password/domain/repositories/change_password_repository.dart';

class ChangePassword extends UseCase<bool,ChangePasswordParams>{
  final ChangePasswordRepository repository;

  ChangePassword({required this.repository});

  @override
  Future<Either<Failure, bool>> call(ChangePasswordParams params) {
    return repository.changePassword(params.oldPassword, params.newPassword);
  }
}

class ChangePasswordParams extends Equatable{
  final String oldPassword;
  final String newPassword;

  const ChangePasswordParams({required this.oldPassword, required this.newPassword});

  @override
  List<Object?> get props => [oldPassword, newPassword];
}