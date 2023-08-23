import 'package:dartz/dartz.dart';
import 'package:flutter_bloc_base/core/error/failures.dart';

abstract class ChangePasswordRepository {
  Future<Either<Failure, bool>> changePassword(String oldPassword, String newPassword);
}