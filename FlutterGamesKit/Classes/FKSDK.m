//
//  FKSDK.m
//  FKSDK
//
//  Created by Paul on 2023/6/13.
//

#import "FKSDK.h"

#import "FKConst.h"
#import "UIDevice+Device.h"

#import <SVProgressHUD/SVProgressHUD.h>
#import "AFNetworking.h"

@interface FKSDK ()

@property (nonatomic, copy) Result initResult;

@property (nonatomic, copy) Result loginResult;

@property (nonatomic, copy) Result submitResult;

@property (nonatomic, copy) Result psyResult;

@property (nonatomic, copy) Result logoutResult;

@property (nonatomic, strong) FlutterMethodChannel *channel;

@property (nonatomic, copy) FlutterResult result;

@end

static FKSDK *manager;

@implementation FKSDK

+ (FKSDK *)shared{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[FKSDK alloc] init];
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
    
    [FKSDK shared].initResult = result;
    [FKSDK sendFlutterMethod:FKSDKInit arguments:arguments];
}

/// 登录
+ (void)sdkLoginWithAuto:(BOOL)flag result:(Result)result{
    [FKSDK shared].loginResult = result;
    [FKSDK sendFlutterMethod:FKSDKLogin arguments:@{@"auto":@(flag)}];
}

/// 上传角色
+ (void)sdkSubmitRoleWithParams:(NSDictionary *)params result:(Result)result{
    [FKSDK shared].submitResult = result;
    [FKSDK sendFlutterMethod:FKSDKSubmitRole arguments:params];
}

/// 支付
+ (void)sdkPsyWithParams:(NSDictionary *)params result:(Result)result{
    [FKSDK shared].psyResult = result;
    [FKSDK sendFlutterMethod:FKSDKPsy arguments:params];
}

/// 登出
+ (void)sdkLogoutWithResult:(Result)result{
    [FKSDK shared].logoutResult = result;
    [FKSDK sendFlutterMethod:FKSDKLogout arguments:@{}];
}

/// 分享
+ (void)sdkShareWithTitle:(NSString *)title image:(NSString *)image url:(NSString *)url  result:(Result)result{
    
    NSMutableDictionary *arguments = [NSMutableDictionary dictionary];
    [arguments addValue:title key:@"title"];
    [arguments addValue:image key:@"image"];
    [arguments addValue:url key:@"url"];
    [FKSDK sendFlutterMethod:FKSDKShare arguments:arguments];
}

/// 打开链接
+ (void)sdkOpenUrlWithUrl:(NSString *)url{
    NSMutableDictionary *arguments = [NSMutableDictionary dictionary];
    [arguments addValue:url key:@"url"];
    [FKSDK sendFlutterMethod:FKSDKOpenUrl arguments:arguments];
}

/// 绑定手机号
+ (void)sdkBindPhone{
    [FKSDK sendFlutterMethod:FKSDKBindPhone arguments:@{}];
}

+ (void)sdkCheckNetBlock:(AFNetBlock)block{
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status == 1 || status == 2) {
            block(true);
        } else {
            block(false);
        }
    }];
    [manager startMonitoring];
}

#pragma mark -- didFinishLaunchingWithOptions
+ (void)sdkApplication:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary<UIApplicationLaunchOptionsKey, id> *)launchOptions{
    
    // 创建代理，做初始化操作
    FKRouter *route = [FKRouter shared];
    FlutterBoost *boost = [FlutterBoost instance];
    
    [boost setup:application delegate:route callback:^(FlutterEngine *engine) {
        
        FKSDK *manager = [FKSDK shared];
        FlutterMethodChannel *channel = [FlutterMethodChannel methodChannelWithName:@"com.sdk.module/methods" binaryMessenger:engine.binaryMessenger];
        manager.channel = channel;
        
        [channel setMethodCallHandler:^(FlutterMethodCall* call, FlutterResult result) {
            
            manager.result = result;
            [FKSDK handel:call];
        }];
    }];
    
    
    
//    [boost addEventListener:^(NSString *name, NSDictionary *arguments) {
//        
//    } forName:@"methods"];
//    
//    [FKSDK shared].boost = boost;
}

#pragma mark -- iOS调用flutter
+ (void)sendFlutterMethod:(NSString *)method arguments:(NSDictionary *)arguments{
    
    FlutterMethodChannel *channel = (FlutterMethodChannel *)[FKSDK shared].channel;
    [channel invokeMethod:method arguments:arguments];
    
//    [[FKSDK shared].boost sendEventToFlutterWith:method arguments:arguments];
}

#pragma mark -- flutter调用iOS
+ (void)handel:(FlutterMethodCall *)call{
    
    FlutterResult result = [FKSDK shared].result;
    if ([@"showPage" isEqualToString:call.method]) {
        
        NSString *route = call.arguments[@"route"];
        NSDictionary *params = call.arguments[@"params"];
        
        FlutterBoostRouteOptions *options = [[FlutterBoostRouteOptions alloc] init];
        options.pageName = route;
        options.uniqueId = route;
        options.arguments = params;
        options.opaque = false;
        [options setOnPageFinished:^(NSDictionary *dict) {
            
        }];
        [[FKRouter shared] pushFlutterRoute:options];
        
    } else if ([@"dismiss" isEqualToString:call.method]) {
        
        [[FKRouter shared].flutterViewContainer dismissViewControllerAnimated:true completion:^{
            result(@(true));
        }];
        
    } else if ([@"HUD" isEqualToString:call.method]) {
        
        NSInteger mode = [call.arguments[@"mode"] integerValue];
        NSString *title = call.arguments[@"title"];
        switch (mode) {
            case 0: [SVProgressHUD show];
                break;
            case 1: [SVProgressHUD dismiss];
                break;
            default: [FKSDK show:title mode:mode completion:^{
                result(@(true));
            }];
                break;
        }
        
    } else if ([FKSDKInitResult isEqualToString:call.method]) {
        
        [FKSDK shared].initResult(call.arguments);
        
    } else if ([FKSDKLoginResult isEqualToString:call.method]) {
        
        
        [FKSDK shared].loginResult(call.arguments);
    } else if ([FKSDKSubmitRoleResult isEqualToString:call.method]) {
        
        
        [FKSDK shared].submitResult(call.arguments);
    } else if ([FKSDKPsyResult isEqualToString:call.method]) {
        
        
        [FKSDK shared].psyResult(call.arguments);
    } else if ([FKSDKLogoutResult isEqualToString:call.method]) {
        
        
        [FKSDK shared].logoutResult(call.arguments);
    } else if ([@"getDeviceInfo" isEqualToString:call.method]) {
        
        
        
    } else {
        result(FlutterMethodNotImplemented);
    }
}

+ (void)show:(NSString *)title mode:(NSInteger)mode completion:(SVProgressHUDDismissCompletion)completion{
    
    switch (mode) {
        case 2: [SVProgressHUD showSuccessWithStatus:title];
            break;
        case 3: [SVProgressHUD showInfoWithStatus:title];
            break;
        case 4: [SVProgressHUD showInfoWithStatus:title];
            break;
        default:
            break;
    }
    
    [SVProgressHUD dismissWithDelay:1.6 completion:completion];
}


@end
