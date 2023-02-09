//
//  FlutterVC.m
//  unit
//
//  Created by Paul on 2023/1/18.
//

#import "FlutterVC.h"
#import "EgretWebViewLib.h"
#import "NSMutableDictionary+YX.h"
#import "NSString+JKDictionaryValue.h"
#import "XWManager.h"
#import "Config.h"
#import "AFNetworking.h"
#import "XWRouter.h"

@interface FlutterVC ()

@property (nonatomic, assign) BOOL isInit;

@end

@implementation FlutterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 常亮
    [UIApplication sharedApplication].idleTimerDisabled = true;
    
    // 加载
    dispatch_async(dispatch_get_global_queue(0, 0), ^{

        [EgretWebViewLib initialize:@"/egretGame/preload/"];
    });
    
    [self checkNet];
}

- (BOOL)prefersStatusBarHidden{
    return true;
}

- (void)addFuncs{
    [EgretWebViewLib setExternalInterface:@"sendToNative" Callback:^(NSString* msg) {
        
        NSLog(@"邹涛: %@", msg);
        
//        [EgretWebViewLib callExternalInterface:@"callJS" Value:@"message from native"];
    }];
    
    [EgretWebViewLib setExternalInterface:@"regsuccess" Callback:^(NSString* msg) {
        
        [self initSDK];
    }];
    
    [EgretWebViewLib setExternalInterface:@"login" Callback:^(NSString* msg) {
        
        [self login];
    }];
    
    [EgretWebViewLib setExternalInterface:@"loadComplete" Callback:^(NSString* msg) {
        
        NSLog(@"message: %@", msg);
    }];
    
    [EgretWebViewLib setExternalInterface:@"pay" Callback:^(NSString* msg) {
        
        NSDictionary *info = [msg jk_dictionaryValue];
        [self psy:info];
    }];
    
    [EgretWebViewLib setExternalInterface:@"upRole" Callback:^(NSString* msg) {

        NSDictionary *info = [msg jk_dictionaryValue];
        [self submitRoleInfo:info];
    }];
    
    [EgretWebViewLib setExternalInterface:@"shareInfo" Callback:^(NSString* msg) {
        
        NSDictionary *info = [msg jk_dictionaryValue];
        [self shareWithMessage:info];
    }];
    
    [EgretWebViewLib setExternalInterface:@"loginout" Callback:^(NSString* msg) {
        
        [XWManager sdkLogoutWithResult:^(NSDictionary * _Nonnull result) {
            [EgretWebViewLib callExternalInterface:@"changeUserSuccess" Value:@"changeUserSuccess"];
        }];
    }];
    
    [EgretWebViewLib setExternalInterface:@"bindPhone" Callback:^(NSString* msg) {
        
        [XWManager sdkBindPhone];
    }];
}

- (void)checkNet{
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];

    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {

        if (status == 1 || status == 2) {
            // 有网，重新加载
            if (self.isInit == false) {
                
                NSString *api = @"https://sqcdn.ayouhuyu.com/stoneage_feeling_debug/index_ios_xmwioscwdzz_https.html?os=ios&pf=xmwioscwdzz&td_channelid=xmwioscwdzz";

                // 启动游戏
                [EgretWebViewLib startGame:api SuperView:self.view];
                
                [self addFuncs];
            }
            UIViewController *vc = [XWRouter currentVC];
            if ([vc isKindOfClass:[UIAlertController class]]) {
                UIAlertController *alert = (UIAlertController *)vc;
                if ([alert.title isEqualToString:@"网络异常"]) {
                    [alert dismissViewControllerAnimated:true completion:nil];
                }
            }
        } else {
            // 没网，展示拦截页
            [self alert];
        }
    }];
    [manager startMonitoring];
}

- (void)alert{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"网络异常" message:@"您的当前网络存在异常，请去检查网络" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        [alert dismissViewControllerAnimated:true completion:nil];
    }];
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
    }];
    
    [alert addAction:action1];
    [alert addAction:action2];
    
    [[XWRouter currentVC] presentViewController:alert animated:true completion:nil];
}

- (void)initSDK{
    
    if (self.isInit) {
        
        [EgretWebViewLib callExternalInterface:@"initSuccess" Value:@"initSuccess"];
        return;
    }
    
    NSDictionary *params = @{
        KEYAppID         : SuperID,
        KEYAppKey        : SuperKey,
        KEYOneLoginAppID : OneLoginAppID,
        KEYLinkSuffix    : LINK,
        KEYAppleID       : AppleID
    };
    [XWManager sdkInitWithParams:params result:^(NSDictionary * _Nonnull result) {
        
        BOOL flag = result[@"flag"];
        if (flag){
            
            self.isInit = true;
            
            [EgretWebViewLib callExternalInterface:@"initSuccess" Value:@"initSuccess"];
        }
    }];
    
}

-(void)login{
    
    // 登录
    [XWManager sdkLoginWithAuto:false result:^(NSDictionary * _Nonnull result) {
        BOOL flag = result[@"flag"];
        if (flag){
            
            NSDictionary *dict = result[@"data"];

            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:nil];
            NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];

            [EgretWebViewLib callExternalInterface:@"loginSuccess" Value:jsonString];
        }
    }];
}

- (void)psy:(NSDictionary *)params{
    
    NSString *serverID    = [NSString stringWithFormat:@"%@",params[@"serverId"]];
    NSString *roleID      = [NSString stringWithFormat:@"%@",params[@"roleID"]];
    NSString *serverName  = [NSString stringWithFormat:@"%@",params[@"serverName"]];
    NSString *roleName    = [NSString stringWithFormat:@"%@",params[@"roleName"]];
    NSString *psyLevel    = [NSString stringWithFormat:@"%@",params[@"payLevel"]];
    NSString *roleLevel   = [NSString stringWithFormat:@"%@",params[@"roleLevel"]];

    NSString *cpOrder    = [NSString stringWithFormat:@"%@",params[@"cpOrder"]];
    NSString *price       = [NSString stringWithFormat:@"%@",params[@"price"]];
    NSString *goodsID    = [NSString stringWithFormat:@"%@",params[@"goodsId"]];
    NSString *goodsName  = [NSString stringWithFormat:@"%@",params[@"goodsName"]];

    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict addValue:roleID key:KEYRoleID];
    [dict addValue:roleName key:KEYRoleName];
    [dict addValue:roleLevel key:KEYRoleLevel];
    [dict addValue:serverID key:KEYServerID];
    [dict addValue:serverName key:KEYServerName];
    [dict addValue:psyLevel key:KEYPsyLevel];
    
    [dict addValue:cpOrder key:KEYCpOrder];
    [dict addValue:price key:KEYPrice];
    [dict addValue:goodsID key:KEYGoodsID];
    [dict addValue:goodsName key:KEYGoodsName];

    [XWManager sdkPsyWithParams:dict result:^(NSDictionary * _Nonnull result) {
        NSLog(@"iOS 支付结果：%@", result);
    }];
}

-(void)submitRoleInfo:(NSDictionary *)params{
    
    NSString *serverID    = [NSString stringWithFormat:@"%@",params[@"serverId"]];
    NSString *roleID      = [NSString stringWithFormat:@"%@",params[@"roleID"]];
    NSString *serverName  = [NSString stringWithFormat:@"%@",params[@"serverName"]];
    NSString *roleName    = [NSString stringWithFormat:@"%@",params[@"roleName"]];
    NSString *psyLevel    = [NSString stringWithFormat:@"%@",params[@"payLevel"]];
    NSString *roleLevel   = [NSString stringWithFormat:@"%@",params[@"roleLevel"]];

    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict addValue:roleID key:KEYRoleID];
    [dict addValue:roleName key:KEYRoleName];
    [dict addValue:roleLevel key:KEYRoleLevel];
    [dict addValue:serverID key:KEYServerID];
    [dict addValue:serverName key:KEYServerName];
    [dict addValue:psyLevel key:KEYPsyLevel];
    
    [XWManager sdkSubmitRoleWithParams:dict result:^(NSDictionary * _Nonnull result) {
        NSLog(@"iOS 角色上报结果：%@", result);
    }];
}

- (void)sdkLoginOut{

    // 退出SDK
    [XWManager sdkLogoutWithResult:^(NSDictionary * _Nonnull result) {
        [EgretWebViewLib callExternalInterface:@"changeUserSuccess" Value:@"changeUserSuccess"];
    }];
}

- (void)shareWithMessage:(NSDictionary *)msg{
    
    NSString *url = msg[@"url"];
    [XWManager sdkShareWithTitle:@"" image:nil url:url result:^(NSDictionary * _Nonnull result) {
        
    }];
}

@end
