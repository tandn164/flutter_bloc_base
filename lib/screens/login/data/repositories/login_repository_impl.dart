import 'package:dartz/dartz.dart';
import 'package:flutter_bloc_base/core/error/exceptions.dart';
import 'package:flutter_bloc_base/core/error/failures.dart';
import 'package:flutter_bloc_base/core/network/network_info.dart';
import 'package:flutter_bloc_base/screens/login/data/datasources/login_local_datasource.dart';
import 'package:flutter_bloc_base/screens/login/data/datasources/login_remote_datasource.dart';
import 'package:flutter_bloc_base/screens/login/data/models/login_model.dart';
import 'package:flutter_bloc_base/screens/login/domain/entities/login.dart';
import 'package:flutter_bloc_base/screens/login/domain/repositories/login_repository.dart';

class LoginRepositoryImpl implements LoginRepository {
  final LoginRemoteDataSource remoteDataSource;
  final LoginLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  LoginRepositoryImpl(
      {required this.remoteDataSource,
      required this.localDataSource,
      required this.networkInfo});

  @override
  Future<Either<Failure, Login>> loginUser(
      String email, String password) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteData = await remoteDataSource.loginUser(email, password);
        localDataSource.cacheToken(LoginModel(token: remoteData.token));
        return Right(remoteData);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(NoConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, Login>> fetchCachedToken() async {
    try {
      final localData = await localDataSource.getLastToken();
      return Right(localData);
    } on CacheException {
      return Left(CacheFailure());
    }
  }
}
