import 'dart:convert';

import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:module/base/ios.dart';
import 'package:module/base/result.dart';
import 'package:module/model/global.dart';
import 'package:module/base/hud.dart';
import 'package:module/base/method.dart';
import 'package:module/base/net.dart';
import 'package:module/model/info.dart';
import 'package:module/model/user.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher_string.dart';

class Manager {
  static late SharedPreferences pref;

  static late FluroRouter router;

  static late Methods methods;

  static Global global = Global();

  static Future sdkInit(Map<String, dynamic> map) async {
    pref = await SharedPreferences.getInstance();

    global.appID = map['appID'];
    global.appKey = map['appKey'];
    global.appleID = map['appleID'];
    global.linkSuffix = map['linkSuffix'];
    global.oneLoginAppID = map['oneLoginAppID'];

    PlatformiOS iOS = PlatformiOS();
    iOS.appName = map['appName'];
    iOS.version = map['version'];
    iOS.bundleVersion = map['bundleVersion'];
    iOS.bundleID = map['bundleID'];
    iOS.model = map['model'];
    iOS.idfa = map['idfa'];
    iOS.uuid = map['uuid'];
    iOS.modelName = map['modelName'];
    iOS.brand = map['brand'];
    iOS.language = map['language'];
    iOS.systemVersion = map['systemVersion'];
    global.iOS = iOS;

    final userjson = pref.getString('userCache');
    if (userjson != null) {
      global.list = json.decode(userjson);

      final map = global.list?.first ?? {};
      global.user = User()
        ..username = map['username']
        ..password = map['password'];
    }

    global = global;

    Net.checkVersion().then((value) {
      if (value.flag) {
        String url = value.data['url'] ?? '';
        if (url.contains('http')) {
          // 更新
          methods.showPage('update', map: {'url': url});
        } else {
          // 检测公告
          _notice();
        }
      } else {
        // 初始化失败
        methods.sdkInitResult(false);
      }
    });
  }

  /// 检测公告
  static Future _notice() async {
    Net.notice().then((value) {
      if (value.flag) {
        final url = value.data['content'] ?? '';
        if (url.contains('http')) {
          // 展示公告
          final date = DateTime.now();
          final now = '${date.year}-${date.month}-${date.day}';

          final old = pref.getString('notice_date') ?? '';
          if (old == now) {
            // 展示过
            // 初始化
            sdkInitRequest();
          } else {
            // 没有展示
            methods.showPage('notice', map: {'url': url});
            pref.setString('notice_date', now);
          }
        } else {
          // 初始化
          sdkInitRequest();
        }
      } else {
        // 初始化失败
        methods.sdkInitResult(false);
      }
    });
  }

  /// 初始化请求
  static sdkInitRequest() {
    Net.init().then((value) {
      if (value.flag) {
        final info = Info();

        info.gameName = value.data["gameName"];
        info.isopensmrz = value.data["is_open_smrz"];
        info.isopenyange = value.data["is_open_yange"];
        info.isopenwxlogin = value.data["is_open_wxlogin"];
        info.wxappid = value.data["wx_appid"];
        info.qqappid = value.data["qqappid"];
        info.isShare = value.data["isShare"];
        info.isuserprotocol = value.data["is_user_protocol"];
        info.userprotocol = value.data["user_protocol"];
        info.universalLink = value.data["Universal_Link"];
        info.exitimageurl = value.data["exit_image_url"];
        info.exitimageclickurl = value.data["exit_image_click_url"];
        info.bftime = value.data["bf_time"];
        info.isgdt = value.data["isgdt"];
        info.userprivate = value.data["user_private"];
        info.smrzshowclosebutton = value.data["smrz_show_close_button"];
        info.cpfangchenmi = value.data["cp_fangchenmi"];
        info.isjmreglogin = value.data["is_jm_reglogin"];
        info.newsid = value.data["newsid"];
        info.questionid = value.data["questionid"];
        info.iosgameid = value.data["ios_gameid"];
        info.androidgameid = value.data["android_gameid"];

        // info.isuserprotocol = '1';
        // info.userprotocol = 'https://www.baidu.com/';

        Map<String, dynamic> map = {
          'newsid': value.data['newsid'],
          'questionid': value.data['questionid'],
          'ios_gameid': value.data['ios_gameid'],
        };

        info.red = map;
        info.isInit = true;
        global.info = info;
        debugPrint('info = $info');
        // 初始化成功
        methods.sdkInitResult(true);
      } else {
        // 初始化失败
        methods.sdkInitResult(false);
      }
    });
  }

  static sdkLogin(Map<String, dynamic> map) {
    if (global.info?.isInit == false) {
      HUD.showFail('初始化失败，请重启游戏，完成初始化操作');
      return;
    }

    if (global.info?.isLogin == true) {
      methods.sdkLoginResult(true,
              {'uid': global.user?.uid, 'name': global.user?.username, 'session': global.user?.sid});
      return;
    }

    bool auto = map['auto'];
    bool isAuto = pref.getBool('AotoLoginCache') ?? false;
    final userjson = pref.getString('userCache');

    if (auto && isAuto && userjson != null) {
      List list = json.decode(userjson);
      final user = list.first;
      String name = user['name'];
      String passwd = user['passwd'];

      sdkLoginRequest(name, passwd);
    } else {
      // 登录页
      methods.showPage('check');
    }
  }

  static Future<Result> sdkLoginRequest(String account, String password) async {
    return Net.login(account, password).then((value) {
      if (value.flag) {
        Map data = value.data;
        User user = User();
        user.uid = data['uid'];
        user.username = data['user_name'];
        user.nickname = data['nick_name'];
        user.profile = data['profile'];
        user.sid = data['sid'];
        user.trueName = data['trueName'];
        user.userSex = data['userSex'];
        user.idCard = data['idCard'];
        user.age = data['age'];
        user.birthday = data['birthday'];
        user.trueNameSwitch = data['trueNameSwitch'];
        user.buoyState = data['buoyState'];
        user.isshowbinding = data['is_show_binding'];
        user.mobile = data['mobile'];
        user.isBindMobile = data['isBindMobile'];
        user.drurl = data['drurl'];
        user.isShare = data['isShare'];
        user.isOldUser = data['isOldUser'];
        user.adult = data['adult'];
        user.issmrz = data['is_smrz'];
        user.wxappid = data['wx_appid'];
        user.qqappid = data['qqappid'];
        user.password = password;
        global.user = user;

        HUD.showSuccess('登录成功').then((value) {
          methods.dismiss();
          methods.sdkLoginResult(true,
              {'uid': user.uid, 'name': user.username, 'session': user.sid});
        });
      } else {
        methods.sdkLoginResult(false, {});
        HUD.showFail(value.msg);
      }
      return value;
    });
  }

  static sdkSubmitRole(Map<String, dynamic> map) {
    Net.submitRole(map).then((value) {
      if (value.flag) {
        HUD.showSuccess('上报成功').then((value) {
          methods.sdkSubmitRoleResult(true);
        });
      } else {
        HUD.showFail(value.msg);
        methods.sdkSubmitRoleResult(true);
      }
    });
  }

  static sdkPsy(Map<String, dynamic> map) {
    HUD.showSuccess('支付成功').then((value) {
      methods.sdkPsyResult(true);
    });
  }

  static sdkLogout(Map<String, dynamic> map) {
    global.info?.isLogin = false;
    HUD.showSuccess('登出成功').then((value) {
      methods.sdkLogoutResult(true);
    });
  }

  static sdkShare(Map<String, dynamic> map) {
    final title = map['title'];
    // final url = map['url'];
    // final image = map['image'];
    Share.share(title);
  }

  static sdkOpenUrl(Map<String, dynamic> map) {
    final url = map['url'];
    launchUrlString(url);
  }

  static sdkBindPhone(Map<String, dynamic> map) {
    methods.showPage('bind');
  }
}
