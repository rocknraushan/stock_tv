import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:stock_tv/authentication/login.dart';
import 'package:stock_tv/authentication/register.dart';
import '../home/home_screen.dart';
import '../splash_screen/splash_screen.dart';

class RouteGenerator {
  static const _id = 'RouteGenerator';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments as dynamic;
    log(_id, name: "Pushed ${settings.name}(${args ?? ''})");
    switch (settings.name) {
      case SplashScreen.id:
        return _route(const SplashScreen());
      case LoginScreen.id:
        return _route(const LoginScreen());
      case RegisterScreen.id:
        return _route(const RegisterScreen());
      case HomeScreen.id:
        return _route( const HomeScreen());
      default:
        return _errorRoute(settings.name);
    }
  }

  static MaterialPageRoute _route(Widget widget) =>
      MaterialPageRoute(builder: (context) => widget);

  static Route<dynamic> _errorRoute(String? name) {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        body: Center(
          child: Text('ROUTE \n\n$name\n\nNOT FOUND'),
        ),
      ),
    );
  }
}