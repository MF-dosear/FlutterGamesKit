//
//  XWManager.h
//  unit
//
//  Created by Paul on 2023/1/6.
//

#import <UIKit/UIKit.h>
#import <Flutter/Flutter.h>
#import "XWKeys.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^Result)(NSDictionary *result);

@interface XWManager : NSObject

@property (nonatomic, strong) id channel;

@property (nonatomic, copy) id result;

@property (nonatomic, copy, readonly) Result initResult;

@property (nonatomic, copy, readonly) Result loginResult;

@property (nonatomic, copy, readonly) Result submitResult;

@property (nonatomic, copy, readonly) Result psyResult;

@property (nonatomic, copy, readonly) Result logoutResult;

/// 实例化
+ (XWManager *)shared;

/// 初始化
+ (void)sdkInitWithParams:(NSDictionary *)params result:(Result)result;

/// 登录
+ (void)sdkLoginWithAuto:(BOOL)flag result:(Result)result;

/// 上传角色
+ (void)sdkSubmitRoleWithParams:(NSDictionary *)params result:(Result)result;

/// 支付
+ (void)sdkPsyWithParams:(NSDictionary *)params result:(Result)result;

/// 登出
+ (void)sdkLogoutWithResult:(Result)result;

/// AppDelegate方法
+ (void)sdkApplication:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary<UIApplicationLaunchOptionsKey, id> *)launchOptions;

/// 分享
+ (void)sdkShareWithTitle:(NSString *)title image:(NSString *)image url:(NSString *)url  result:(Result)result;

/// 打开链接
+ (void)sdkOpenUrlWithUrl:(NSString *)url;

/// 绑定手机号
+ (void)sdkBindPhone;

@end

NS_ASSUME_NONNULL_END
