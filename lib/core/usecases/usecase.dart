import 'package:dartz/dartz.dart';
import 'package:flutter_bloc_base/core/error/failures.dart';

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}
