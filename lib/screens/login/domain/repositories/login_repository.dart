import 'package:dartz/dartz.dart';
import 'package:flutter_bloc_base/core/error/failures.dart';
import 'package:flutter_bloc_base/screens/login/domain/entities/login.dart';

abstract class LoginRepository {
  Future<Either<Failure, Login>> loginUser(String email, String password);
  Future<Either<Failure, Login>> fetchCachedToken();
}
