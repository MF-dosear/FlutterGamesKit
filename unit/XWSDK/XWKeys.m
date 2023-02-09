//
//  XWKeys.m
//  unit
//
//  Created by Paul on 2023/1/11.
//

#import "XWKeys.h"

/// 初始化信息
/// Apple ID
NSString * const KEYAppleID = @"appleID";
/// super appID
NSString * const KEYAppID = @"appID";
/// super appkey
NSString * const KEYAppKey = @"appKey";
/// link后缀 包名
NSString * const KEYLinkSuffix = @"linkSuffix";
/// 一键登录
NSString * const KEYOneLoginAppID = @"oneLoginAppID";

/// 角色信息
/// 服务器名字
NSString * const KEYServerName = @"serverName";
/// 游戏区服
NSString * const KEYServerID = @"serverID";
/// 角色名
NSString * const KEYRoleName = @"roleName";
/// 角色ID
NSString * const KEYRoleID = @"roleID";
/// 角色等级
NSString * const KEYRoleLevel = @"roleLevel";
/// Vip等级
NSString * const KEYPsyLevel = @"psyLevel";

/// 订单信息
/// cp方产生的订单(必传)
NSString * const KEYCpOrder = @"cpOrder";
/// 支付需要的价格单位(元)(必传)
NSString * const KEYPrice = @"price";
/// 商品号(必传)
NSString * const KEYGoodsID = @"goodsID";
/// 商品名称
NSString * const KEYGoodsName = @"goodsName";
/// 拓展字段
NSString * const KEYExtends = @"extends";
/// 回调地址
NSString * const KEYNotify = @"notify";
