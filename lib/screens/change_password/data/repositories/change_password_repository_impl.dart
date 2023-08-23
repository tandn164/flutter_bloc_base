import 'package:dartz/dartz.dart';
import 'package:flutter_bloc_base/core/error/exceptions.dart';
import 'package:flutter_bloc_base/core/error/failures.dart';
import 'package:flutter_bloc_base/core/network/network_info.dart';
import 'package:flutter_bloc_base/screens/change_password/data/datasources/change_password_local_datasource.dart';
import 'package:flutter_bloc_base/screens/change_password/data/datasources/change_password_remote_datasource.dart';
import 'package:flutter_bloc_base/screens/change_password/domain/repositories/change_password_repository.dart';

class ChangePasswordRepositoryImpl implements ChangePasswordRepository {
  final ChangePasswordRemoteDataSource remoteDataSource;
  final ChangePasswordLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  ChangePasswordRepositoryImpl(
      {required this.remoteDataSource,
      required this.localDataSource,
      required this.networkInfo});

  @override
  Future<Either<Failure, bool>> changePassword(String oldPassword, String newPassword) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.changePassword(oldPassword, newPassword);
        return Right(result);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(NoConnectionFailure());
    }
  }
}
