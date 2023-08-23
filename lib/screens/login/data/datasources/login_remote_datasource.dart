import 'dart:convert';

import 'package:flutter_bloc_base/core/error/exceptions.dart';
import 'package:flutter_bloc_base/core/network/rest_client_service.dart';
import 'package:flutter_bloc_base/screens/login/data/models/login_model.dart';
import 'package:flutter_bloc_base/screens/login/domain/entities/login.dart';

abstract class LoginRemoteDataSource {
  Future<Login> loginUser(String email, String password);
}

class LoginRemoteDataSourceImpl extends LoginRemoteDataSource {
  final RestClientService restClientService;

  LoginRemoteDataSourceImpl({required this.restClientService});

  @override
  Future<Login> loginUser(String email, String password) async {
    final response = await restClientService.loginUser(jsonEncode({
      'email': email,
      'password': password,
    }));
    if (response.statusCode != 200) {
      throw ServerException();
    }
    return LoginModel.fromJson(jsonDecode(response.body));
  }
}
