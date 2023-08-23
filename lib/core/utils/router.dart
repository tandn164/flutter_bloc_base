import 'package:flutter/material.dart';
import 'package:flutter_bloc_base/screens/change_password/presentation/page/change_password.dart';
import 'package:flutter_bloc_base/screens/home/presentation/page/home.dart';
import 'package:flutter_bloc_base/screens/login/presentation/page/login.dart';
import 'constants.dart';

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case LOGIN_ROUTE:
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case HOME_ROUTE:
        return MaterialPageRoute(builder: (_) => const HomePage());
      case CHANGE_PASSWORD_ROUTE:
        return MaterialPageRoute(builder: (_) => const ChangePasswordPage());
      default:
        return MaterialPageRoute(builder: (_) => const LoginPage());
    }
  }
}
