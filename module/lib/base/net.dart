import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:module/base/http.dart';
import 'package:module/base/manager.dart';
import 'package:module/base/result.dart';

class Net {
// 注册
  static String apiPathUserReg = "sdk.user.reg";

// 手机注册
  static String apiPathMobildeReg = "sdk.user.mobileReg";

// 获取验证码
  static String apiPathCode = "sdk.user.code";

// 验证验证码
  static String apiPathCheckCode = "sdk.user.checkUserMobileCode";

// 忘记密码
  static String apiPathEditNewPwd =
      "sdk.user.updateByPhonePwd"; //sdk.user.updatePwd

// 绑定手机
  static String apiPathBindMobile = "sdk.user.bindMobile";

//
  static String apiPathWXLogin = "sdk.user.wxLogin";

// 实名认证
  static String apiPathShiMingValidate = "sdk.game.shimingvalidate";

// 上传角色信息
  static String apiPathEnter = "sdk.game.entergame";

// 获取状态
  static String apiPathState = "sdk.pay.getPayState";

// 获取订单号
  static String apiPathOrder = "sdk.pay.fororder";

// 苹果支付
//static String apiPathApplePsy        = "sdk_apple_pay";

// 苹果支付 2
  static String apiPathApple2 = "sdk.pay.apple2";

// 验证订单
  static String apiPathQuery = "sdk.pay.query2";

// 一键登录
  static String apiPathOneLogin = "ioslogin";

// 重置密码
  static String apiPathResetPwd = "sdk.user.aliAutoUpdatePwd";

  static Future<Result> checkVersion() async {
    final version = Manager.global.iOS?.version?.replaceAll('.', '');
    final params = {'gameversion': version};

    return Http.post('sdk.info.versionUpdate', params);
  }

  static Future<Result> notice() async {
    return Http.post('sdk.info.announcement', {});
  }

  static Future<Result> init() async {
    return Http.post('sdk.game.initsdk', {});
  }

  static Future<Result> login(String name, String passwd) async {
    final params = {
      'username': name,
      'passwd': md5.convert(utf8.encode(passwd)).toString(),
      'passwdMW': passwd,
    };
    return Http.post('sdk.user.login', params);
  }

  static Future<Result> regiest(String name, String passwd) async {
    final params = {
      'username': name,
      'passwd': md5.convert(utf8.encode(passwd)).toString(),
    };
    return Http.post('sdk.user.reg', params);
  }

  static Future<Result> sendMsg(
      String username, String mobile, int smsType) async {
    final params = {
      'username': username,
      'mobile': mobile,
      'smsType': smsType,
    };
    return Http.post('sdk.user.code', params);
  }

  static Future<Result> phoneLogin(String mobile, String code) async {
    final params = {'mobile': mobile, 'code': code};
    return Http.post('sdk.user.codelogin', params);
  }

  static Future<Result> phoneRegiest(
      String mobile, String code, String passwd) async {
    final params = {
      'username': mobile,
      'code': code,
      'passwd': md5.convert(utf8.encode(passwd)).toString(),
    };
    return Http.post('sdk.user.mobileReg', params);
  }

  static Future<Result> resetPwd(
      String mobile, String code, String passwd) async {
    final params = {
      'username': mobile,
      'mobile': mobile,
      'code': code,
      'passwd': md5.convert(utf8.encode(passwd)).toString(),
      'passwdMW': passwd,
    };
    return Http.post('sdk.user.updateByPhonePwd', params);
  }

  static Future<Result> auth(String name, String idcard) async {
    final params = {
      'username': Manager.global.user?.username ?? '',
      'name': name,
      'idcard': idcard,
      'uid': Manager.global.user?.uid ?? '',
    };
    return Http.post('sdk.game.shimingvalidate', params);
  }

  static Future<Result> bindPhone(String mobile, String code) async {
    final params = {
      'mobile': mobile,
      'code': code,
      'username': Manager.global.user?.username ?? '',
      'passwdMW': Manager.global.user?.password ?? '',
    };
    return Http.post('sdk.user.bindMobile', params);
  }

  static Future<Result> submitRole(Map<String, dynamic> map) async {
    final params = {
      'username': Manager.global.user?.username ?? '',
      'uid': Manager.global.user?.uid ?? '',
    };
    map.addAll(params);
    debugPrint('params = $map');
    return Http.post('sdk.game.entergame', map);
  }
}
