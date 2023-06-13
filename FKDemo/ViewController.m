//
//  ViewController.m
//  unit
//
//  Created by Paul on 2023/1/4.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self sdkInit];
}

- (void)sdkInit{
    NSDictionary *params = @{
        KEYAppID         : AppID,
        KEYAppKey        : AppKey,
        KEYOneLoginAppID : OneLoginAppID,
        KEYLinkSuffix    : LinkSuffix,
        KEYAppleID       : AppleID
    };
    [FKSDK sdkInitWithParams:params result:^(NSDictionary * _Nonnull result) {
        NSLog(@"iOS 初始化结果：%@", result);
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.row == 0){
        [self sdkInit];
    } else if (indexPath.row == 1) {
        [FKSDK sdkLoginWithAuto:false result:^(NSDictionary * _Nonnull result) {
            NSLog(@"iOS 登录结果：%@", result);
        }];
    } else if (indexPath.row == 2) {
        NSDictionary *params = @{
            
            KEYRoleID: @"roleID",
            KEYRoleName : @"roleName",
            KEYRoleLevel : @"roleLevel",
            
            KEYServerID : @"serverId",
            KEYServerName : @"serverName",
            KEYPsyLevel : @"payLevel"
        };
        
        [FKSDK sdkSubmitRoleWithParams:params result:^(NSDictionary * _Nonnull result) {
            NSLog(@"iOS 角色上报结果：%@", result);
        }];
    } else if (indexPath.row == 3) {
        NSDictionary *params = @{
            
            KEYRoleID: @"roleID",
            KEYRoleName : @"roleName",
            KEYRoleLevel : @"roleLevel",
            KEYServerID : @"serverId",
            KEYServerName : @"serverName",
            KEYPsyLevel : @"payLevel",
            
            KEYCpOrder : @"cpOrder",
            KEYPrice : @"price",
            KEYGoodsID : @"goodsId",
            KEYGoodsName : @"goodsName"
        };
        [FKSDK sdkPsyWithParams:params result:^(NSDictionary * _Nonnull result) {
            NSLog(@"iOS 支付结果：%@", result);
        }];
    } else if (indexPath.row == 4) {
        [FKSDK sdkLogoutWithResult:^(NSDictionary * _Nonnull result) {
            NSLog(@"iOS 登出结果：%@", result);
        }];
    } else if (indexPath.row == 5) {
        [FKSDK sdkShareWithTitle:@"分享内容" image:@"" url:@"" result:^(NSDictionary * _Nonnull result) {
            
        }];
    } else if (indexPath.row == 6) {
        [FKSDK sdkOpenUrlWithUrl:@"https://www.baidu.com/"];
    } else if (indexPath.row == 7) {
        [FKSDK sdkBindPhone];
    }
}

@end
