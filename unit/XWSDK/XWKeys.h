//
//  XWKeys.h
//  unit
//
//  Created by Paul on 2023/1/11.
//

#import <UIKit/UIKit.h>

/// 初始化信息
/// Apple ID
UIKIT_EXTERN NSString * const KEYAppleID;
/// super appid
UIKIT_EXTERN NSString * const KEYAppID;
/// super appkey
UIKIT_EXTERN NSString * const KEYAppKey;
/// link后缀 包名
UIKIT_EXTERN NSString * const KEYLinkSuffix;
/// 一键登录
UIKIT_EXTERN NSString * const KEYOneLoginAppID;

/// 角色信息
/// 服务器名字
UIKIT_EXTERN NSString * const KEYServerName;
/// 游戏区服
UIKIT_EXTERN NSString * const KEYServerID;
/// 角色名
UIKIT_EXTERN NSString * const KEYRoleName;
/// 角色id
UIKIT_EXTERN NSString * const KEYRoleID;
/// 角色等级
UIKIT_EXTERN NSString * const KEYRoleLevel;
/// Vip等级
UIKIT_EXTERN NSString * const KEYPsyLevel;

/// 订单信息
/// cp方产生的订单(必传)
UIKIT_EXTERN NSString * const KEYCpOrder;
/// 支付需要的价格单位(元)(必传)
UIKIT_EXTERN NSString * const KEYPrice;
/// 商品号(必传)
UIKIT_EXTERN NSString * const KEYGoodsID;
/// 商品名称
UIKIT_EXTERN NSString * const KEYGoodsName;
/// 拓展字段
UIKIT_EXTERN NSString * const KEYExtends;
/// 回调地址
UIKIT_EXTERN NSString * const KEYNotify;
