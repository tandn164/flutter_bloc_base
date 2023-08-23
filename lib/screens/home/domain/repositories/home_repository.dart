import 'package:dartz/dartz.dart';
import 'package:flutter_bloc_base/core/error/failures.dart';

abstract class HomeRepository {
  Future<Either<Failure, bool>> logoutUser(String token);
}
