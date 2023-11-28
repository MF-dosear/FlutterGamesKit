import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:module/base/manager.dart';
import 'package:module/page/auth.dart';
import 'package:module/page/forget.dart';
import 'package:module/page/login.dart';
import 'package:module/page/phone.dart';
import 'package:module/page/quick.dart';
import 'package:module/page/regiest.dart';
import 'package:module/page/reset.dart';
import 'package:module/page/tips.dart';

//配置路由名称
class Routes {
  static String root = '/'; //根路径
  static String login = '/login';
  static String center = '/center';
  static String phoneLogin = '/phoneLogin';
  static String quickLogin = '/quickLogin';
  static String forget = '/forget';
  static String phoneRegiest = '/phoneRegiest';
  static String reset = '/reset';
  static String auth = '/auth';
  static String tips = '/tips';

  static void configureRoutes(FluroRouter router) {
    router.notFoundHandler = Handler(
      handlerFunc: (context, parameters) {
        debugPrint('ERROR====>ROUTE WAS NOT FONUND!!!');
        return null;
      },
    );

    router.define(login,
        handler:
            Handler(handlerFunc: (context, parameters) => const LoginPage()));
    router.define(phoneLogin,
        handler: Handler(
            handlerFunc: (context, parameters) => const PhoneLoginPage()));
    router.define(quickLogin,
        handler: Handler(
            handlerFunc: (context, parameters) => const QuickLoginPage()));
    router.define(forget,
        handler:
            Handler(handlerFunc: (context, parameters) => const ForgetPage()));
    router.define(phoneRegiest,
        handler: Handler(
            handlerFunc: (context, parameters) => const PhoneRegPage()));
    router.define(reset,
        handler:
            Handler(handlerFunc: (context, parameters) => const ResetPage()));
    router.define(auth,
        handler:
            Handler(handlerFunc: (context, parameters) => const AuthPage()));
    router.define(tips,
        handler:
            Handler(handlerFunc: (context, parameters) => const TipsPage()));
  }

  // 自定义的参数跳转
  // 对参数进行encode，解决参数中有特殊字符，影响fluro路由匹配
  static Future navigateTo(BuildContext context, String path,
      {Map<String, dynamic>? params,
      TransitionType transition = TransitionType.fadeIn}) {
    String query = "";
    if (params != null) {
      int index = 0;
      for (var key in params.keys) {
        var value = Uri.encodeComponent(params[key]);
        if (index == 0) {
          query = "?";
        } else {
          query = '$query\\&';
        }
        query += "$key=$value";
        index++;
      }
    }
    path = path + query;
    return Manager.router.navigateTo(context, path, transition: transition);
  }
}
