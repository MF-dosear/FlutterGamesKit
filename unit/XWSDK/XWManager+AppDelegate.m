//
//  XWManager+AppDelegate.m
//  unit
//
//  Created by Paul on 2023/1/10.
//

#import "XWManager+AppDelegate.h"
#import "XWRouter.h"
#import "XWManager+Flutter.h"

@implementation XWManager (AppDelegate)

+ (void)sdkApplication:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary<UIApplicationLaunchOptionsKey, id> *)launchOptions{
    
    // 创建代理，做初始化操作
    XWRouter *route = [XWRouter shared];
    [[FlutterBoost instance] setup:application delegate:route callback:^(FlutterEngine *engine) {
        
        XWManager *manager = [XWManager shared];
        
        FlutterViewController *vc = engine.viewController;
        FlutterMethodChannel *channel = [FlutterMethodChannel methodChannelWithName:@"com.sdk.module/methods" binaryMessenger:vc.binaryMessenger];
        manager.channel = channel;
        
        [channel setMethodCallHandler:^(FlutterMethodCall* call, FlutterResult result) {
            
            manager.result = result;
            [XWManager handel:call];
        }];
        
    }];
}



@end
