//
//  FUAppDelegate.m
//  FlutterGamesKit
//
//  Created by Paul on 11/28/2023.
//  Copyright (c) 2023 罗小黑不吹. All rights reserved.
//

#import "AppDelegate.h"
#import <FlutterGamesKit/FlutterGamesKit-umbrella.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    
    [FKSDK sdkApplication:application didFinishLaunchingWithOptions:launchOptions];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    UINavigationController *nvc = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"root"];
    self.window.rootViewController = nvc;
    
    return YES;
}

@end
