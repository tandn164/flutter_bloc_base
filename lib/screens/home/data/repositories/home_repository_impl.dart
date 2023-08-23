import 'package:dartz/dartz.dart';
import 'package:flutter_bloc_base/core/error/exceptions.dart';
import 'package:flutter_bloc_base/core/error/failures.dart';
import 'package:flutter_bloc_base/core/network/network_info.dart';
import 'package:flutter_bloc_base/screens/home/data/datasources/home_local_datasource.dart';
import 'package:flutter_bloc_base/screens/home/data/datasources/home_remote_datasource.dart';
import 'package:flutter_bloc_base/screens/home/domain/repositories/home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource remoteDataSource;
  final HomeLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  HomeRepositoryImpl(
      {required this.remoteDataSource,
      required this.localDataSource,
      required this.networkInfo});

  @override
  Future<Either<Failure, bool>> logoutUser(String token) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.logoutUser(token);
        try {
          await localDataSource.clearToken();
          return const Right(true);
        } on CacheException {
          return Left(CacheFailure());
        }
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(NoConnectionFailure());
    }
  }
}
