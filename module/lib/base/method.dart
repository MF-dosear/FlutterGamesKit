import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:module/base/manager.dart';

enum HUDMode {
  none,
  dismiss,
  success,
  fail,
  info,
}

class Methods {

  final _channel = const MethodChannel('com.sdk.module/methods');

  Future regiestMethod() async {
    _channel.setMethodCallHandler((call) async {
      Map<String, dynamic> map = Map<String, dynamic>.from(call.arguments);
      if (call.method == 'sdkInit') {
        Manager.sdkInit(map);
      } else if (call.method == 'sdkLogin') {
        Manager.sdkLogin(map);
      } else if (call.method == 'sdkSubmitRole') {
        Manager.sdkSubmitRole(map);
      } else if (call.method == 'sdkPsy') {
        Manager.sdkPsy(map);
      } else if (call.method == 'sdkLogout') {
        Manager.sdkLogout(map);
      } else if (call.method == 'sdkShare') {
        Manager.sdkShare(map);
      }else if (call.method == 'sdkOpenUrl') {
        Manager.sdkOpenUrl(map);
      }else if (call.method == 'sdkBindPhone') {
        Manager.sdkBindPhone(map);
      } else {
        return null;
      }
    });
  }

  Future show(HUDMode mode, {String? title}) async {
    int type = 0;
    switch (mode) {
      case HUDMode.dismiss:
        type = 1;
        break;
      case HUDMode.success:
        type = 2;
        break;
      case HUDMode.fail:
        type = 3;
        break;
      case HUDMode.info:
        type = 4;
        break;
      default:
        type = 0;
    }

    final params = {
      'mode': type,
      'title': title,
    };

    return _channel.invokeMethod('HUD', params);
  }

  showPage(String route, {Map<String, dynamic>? map}) {
    final params = {
      'route': route,
      'params': map ?? {},
    };
    _channel.invokeMethod('showPage', params);
  }

  dismiss() {
    _channel.invokeMethod('dismiss', {});
  }

  sdkInitResult(bool flag) {
    _channel.invokeMethod('sdkInitResult', {'flag': flag});
  }

  sdkLoginResult(bool flag, Map<String, dynamic> params) {
    if (flag) {
      // 登录成功
      Manager.global.info?.isLogin = true;

      // 存储信息
      final list = Manager.global.list ?? [];
      bool isHave = false;
      for (var map in list) {
        if (Manager.global.user?.username == map['username']) {
          isHave = true;
        }
      }
      if (isHave == false) {
        list.insert(0, {
          'username': Manager.global.user?.username,
          'password': Manager.global.user?.password,
        });
        Manager.global.list = list;
        Manager.pref.setString('userCache', json.encode(list));
      }
    }

    _channel.invokeMethod('sdkLoginResult', {
      'flag': flag,
      'data': params,
    });
  }

  sdkSubmitRoleResult(bool flag) {
    _channel.invokeMethod('sdkSubmitRoleResult', {'flag': flag});
  }

  sdkPsyResult(bool flag) {
    _channel.invokeMethod('sdkPsyResult', {'flag': flag});
  }

  sdkLogoutResult(bool flag) {
    _channel.invokeMethod('sdkLogoutResult', {'flag': flag});
  }
}
