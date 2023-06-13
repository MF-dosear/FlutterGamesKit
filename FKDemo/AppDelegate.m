//
//  AppDelegate.m
//  unit
//
//  Created by Paul on 2023/1/4.
//

#import "AppDelegate.h"
//#import "FlutterVC.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary<UIApplicationLaunchOptionsKey, id> *)launchOptions {
    
    [FKSDK sdkApplication:application didFinishLaunchingWithOptions:launchOptions];
    
//    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
//    self.window.backgroundColor = [UIColor whiteColor];
//    [self.window makeKeyAndVisible];
//
//    self.window.rootViewController = [[FlutterVC alloc] init];
    
    return true;
}

@end
