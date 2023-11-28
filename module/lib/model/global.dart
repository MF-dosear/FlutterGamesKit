import 'package:module/base/android.dart';
import 'package:module/base/ios.dart';
import 'package:module/model/info.dart';
import 'package:module/model/user.dart';

class Global {
  Global();

  /// 初始化信息
  /// Apple ID
  String? appleID;

  /// super appid
  String? appID;

  /// super appkey
  String? appKey;

  /// link后缀 包名
  String? linkSuffix;

  /// 一键登录 appid
  String? oneLoginAppID;

  /// 角色信息
  /// 服务器名字
  String? serverName;

  /// 游戏区服
  String? serverID;

  /// 角色名
  String? roleName;

  /// 角色id
  String? roleID;

  /// 角色等级
  String? roleLevel;

  /// Vip等级
  String? psyLevel;

  /// 订单信息
  /// cp方产生的订单(必传)
  String? cpOrder;

  /// 支付需要的价格单位(元)(必传)
  String? price;

  /// 商品号(必传)
  String? goodsID;

  /// 商品名称
  String? goodsName;

  /// 拓展字段
  String? extend;

  /// 回调地址
  String? notify;

  // 初始化信息
  Info? info;

  // 用户信息
  User? user;

  // 用户列表
  List? list;

  PlatformiOS? iOS;

  PlatformAndroid? android;
}
