//
//  XWManager.m
//  unit
//
//  Created by Paul on 2023/1/6.
//

#import "XWManager.h"
#import "XWManager+iOS.h"
#import "XWConst.h"
#import "UIDevice+Device.h"
#import "NSMutableDictionary+YX.h"
#import "SVProgressHUD.h"

@interface XWManager ()

@property (nonatomic, copy, readwrite) Result initResult;

@property (nonatomic, copy, readwrite) Result loginResult;

@property (nonatomic, copy, readwrite) Result submitResult;

@property (nonatomic, copy, readwrite) Result psyResult;

@property (nonatomic, copy, readwrite) Result logoutResult;

@end

static XWManager *manager;

@implementation XWManager

+ (XWManager *)shared{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[XWManager alloc] init];
    });
    return manager;
}

/// 初始化
+ (void)sdkInitWithParams:(NSDictionary *)params result:(Result)result{
    
    // 设置风格
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeNative];
    
    // 初始化参数
    NSMutableDictionary *arguments = [params mutableCopy];
    
    NSDictionary *dict = [[NSBundle mainBundle] infoDictionary];
    
    [arguments addValue:dict[@"CFBundleName"]               key:@"appName"];
    [arguments addValue:dict[@"CFBundleShortVersionString"] key:@"version"];
    [arguments addValue:dict[@"CFBundleVersion"]            key:@"bundleVersion"];
    [arguments addValue:dict[@"CFBundleIdentifier"]         key:@"bundleID"];
    
    [arguments addValue:[UIDevice model]            key:@"model"];
    [arguments addValue:[UIDevice idfa]             key:@"idfa"];
    [arguments addValue:[UIDevice uuidWithKeychain] key:@"uuid"];
    
    [arguments addValue:[UIDevice modelName]    key:@"modelName"];
    [arguments addValue:[UIDevice brand]        key:@"brand"];
    [arguments addValue:[UIDevice language]     key:@"language"];
    
    [arguments addValue:[UIDevice systemVersion] key:@"systemVersion"];
    
    [XWManager shared].initResult = result;
    [XWManager sendFlutterMethod:XWSDKInit arguments:arguments];
}

/// 登录
+ (void)sdkLoginWithAuto:(BOOL)flag result:(Result)result{
    [XWManager shared].loginResult = result;
    [XWManager sendFlutterMethod:XWSDKLogin arguments:@{@"auto":@(flag)}];
}

/// 上传角色
+ (void)sdkSubmitRoleWithParams:(NSDictionary *)params result:(Result)result{
    [XWManager shared].submitResult = result;
    [XWManager sendFlutterMethod:XWSDKSubmitRole arguments:params];
}

/// 支付
+ (void)sdkPsyWithParams:(NSDictionary *)params result:(Result)result{
    [XWManager shared].psyResult = result;
    [XWManager sendFlutterMethod:XWSDKPsy arguments:params];
}

/// 登出
+ (void)sdkLogoutWithResult:(Result)result{
    [XWManager shared].logoutResult = result;
    [XWManager sendFlutterMethod:XWSDKLogout arguments:@{}];
}

/// 分享
+ (void)sdkShareWithTitle:(NSString *)title image:(NSString *)image url:(NSString *)url  result:(Result)result{
    
    NSMutableDictionary *arguments = [NSMutableDictionary dictionary];
    [arguments addValue:title key:@"title"];
    [arguments addValue:image key:@"image"];
    [arguments addValue:url key:@"url"];
    [XWManager sendFlutterMethod:XWSDKShare arguments:arguments];
}

/// 打开链接
+ (void)sdkOpenUrlWithUrl:(NSString *)url{
    NSMutableDictionary *arguments = [NSMutableDictionary dictionary];
    [arguments addValue:url key:@"url"];
    [XWManager sendFlutterMethod:XWSDKOpenUrl arguments:arguments];
}

/// 绑定手机号
+ (void)sdkBindPhone{
    [XWManager sendFlutterMethod:XWSDKBindPhone arguments:@{}];
}

@end
