import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'package:module/base/manager.dart';
import 'package:module/base/method.dart';
import 'package:module/base/route.dart';
import 'package:module/page/bind.dart';
import 'package:module/page/check.dart';
import 'package:module/page/login.dart';
import 'package:module/page/notice.dart';
import 'package:module/page/update.dart';

void main() {
  // 路由初始化
  final router = FluroRouter();
  Routes.configureRoutes(router);
  Manager.router = router;

  ///这里的CustomFlutterBinding调用务必不可缺少，用于控制Boost状态的resume和pause
  CustomFlutterBinding();
  runApp(const MyApp());
}

///创建一个自定义的Binding，继承和with的关系如下，里面什么都不用写
class CustomFlutterBinding extends WidgetsFlutterBinding
    with BoostFlutterBinding {}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  /// 由于很多同学说没有跳转动画，这里是因为之前exmaple里面用的是 [PageRouteBuilder]，
  /// 其实这里是可以自定义的，和Boost没太多关系，比如我想用类似iOS平台的动画，
  /// 那么只需要像下面这样写成 [CupertinoPageRoute] 即可
  /// (这里全写成[MaterialPageRoute]也行，这里只不过用[CupertinoPageRoute]举例子)
  ///
  /// 注意，如果需要push的时候，两个页面都需要动的话，
  /// （就是像iOS native那样，在push的时候，前面一个页面也会向左推一段距离）
  /// 那么前后两个页面都必须是遵循CupertinoRouteTransitionMixin的路由
  /// 简单来说，就两个页面都是CupertinoPageRoute就好
  /// 如果用MaterialPageRoute的话同理
  ///
  ///

  @override
  void initState() {
    final methods = Methods();
    methods.regiestMethod();
    Manager.methods = methods;

    super.initState();
  }

  ///路由表
  static Map<String, FlutterBoostRouteFactory> routerMap = {
    'check': (settings, uniqueId) {
      return MaterialPageRoute(
          settings: settings,
          builder: (_) {
            return const CheckPage();
          });
    },
    'login': (settings, uniqueId) {
      return MaterialPageRoute(
          settings: settings,
          builder: (_) {
            // Map<String, Object> map = settings.arguments as Map<String, Object> ;
            // String data = map['data'] as String;
            return const LoginPage();
          });
    },
    'update': (settings, uniqueId) {
      return MaterialPageRoute(
          settings: settings,
          builder: (_) {
            Map map = settings.arguments as Map;
            return UpdatePage(url: map['url']);
          });
    },
    'notice': (settings, uniqueId) {
      return MaterialPageRoute(
          settings: settings,
          builder: (_) {
            Map map = settings.arguments as Map;
            return NoticePage(url: map['url']);
          });
    },
    'bind': (settings, uniqueId) {
      return MaterialPageRoute(
          settings: settings,
          builder: (_) {
            return const BindPhonePage();
          });
    },
  };

  Route<dynamic>? routeFactory(RouteSettings settings, String? uniqueId) {
    FlutterBoostRouteFactory? func = routerMap[settings.name];
    return func == null ? null : func(settings, uniqueId);
  }

  Widget appBuilder(Widget home) {
    return MaterialApp(
      home: home,
      debugShowCheckedModeBanner: false,
      onGenerateRoute: Manager.router.generator,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FlutterBoostApp(
      routeFactory,
      appBuilder: appBuilder,
      initialRoute: 'check',
    );
  }
}
