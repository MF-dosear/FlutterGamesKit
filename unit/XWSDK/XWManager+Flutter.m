//
//  XWManager+Flutter.m
//  unit
//
//  Created by Paul on 2023/1/10.
//

#import "XWManager+Flutter.h"
#import "XWRouter.h"
#import "XWConst.h"
#import "SVProgressHUD.h"

@implementation XWManager (Flutter)

+ (void)handel:(FlutterMethodCall *)call{
    
    FlutterResult result = [XWManager shared].result;
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
        [[XWRouter shared] pushFlutterRoute:options];
        
    } else if ([@"dismiss" isEqualToString:call.method]) {
        
        [[XWRouter shared].flutterViewContainer dismissViewControllerAnimated:true completion:^{
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
            default: [XWManager show:title mode:mode completion:^{
                result(@(true));
            }];
                break;
        }
        
    } else if ([XWSDKInitResult isEqualToString:call.method]) {
        
        [XWManager shared].initResult(call.arguments);
        
    } else if ([XWSDKLoginResult isEqualToString:call.method]) {
        
        
        [XWManager shared].loginResult(call.arguments);
    } else if ([XWSDKSubmitRoleResult isEqualToString:call.method]) {
        
        
        [XWManager shared].submitResult(call.arguments);
    } else if ([XWSDKPsyResult isEqualToString:call.method]) {
        
        
        [XWManager shared].psyResult(call.arguments);
    } else if ([XWSDKLogoutResult isEqualToString:call.method]) {
        
        
        [XWManager shared].logoutResult(call.arguments);
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
