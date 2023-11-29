//
//  FKSDK.h
//  FKSDK
//
//  Created by Paul on 2023/6/13.
//

#import "FKKeys.h"
#import "FKRouter.h"
#import "NSMutableDictionary+YX.h"
#import "NSString+JKDictionaryValue.h"

//! Project version number for FKSDK.
FOUNDATION_EXPORT double FKSDKVersionNumber;

//! Project version string for FKSDK.
FOUNDATION_EXPORT const unsigned char FKSDKVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <FKSDK/PublicHeader.h>
// '../module'

typedef void (^AFNetBlock)(BOOL isNet);

typedef void(^Result)(NSDictionary * _Nullable result);

NS_ASSUME_NONNULL_BEGIN

@interface FKSDK : NSObject

@property (nonatomic, strong) FlutterBoost *boost;

/// AppDelegate方法
+ (void)sdkApplication:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary<UIApplicationLaunchOptionsKey, id> *)launchOptions;

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

/// 分享
+ (void)sdkShareWithTitle:(NSString *)title image:(NSString *)image url:(NSString *)url  result:(Result)result;

/// 打开链接
+ (void)sdkOpenUrlWithUrl:(NSString *)url;

/// 绑定手机号
+ (void)sdkBindPhone;

/// 检查网络
+ (void)sdkCheckNetBlock:(AFNetBlock)block;

@end

NS_ASSUME_NONNULL_END
