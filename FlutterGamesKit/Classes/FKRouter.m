//
//  Router.m
//  unit
//
//  Created by Paul on 2023/1/10.
//

#import "FKRouter.h"
#import <FlutterPluginRegistrant/GeneratedPluginRegistrant.h>

typedef void(^BoostonPageFinished)(NSDictionary *);

@interface FKRouter ()<FlutterBoostDelegate>

///用来存返回flutter侧返回结果的表
@property (nonatomic, strong) NSMutableDictionary *resultTable;

@end

static FKRouter *route;

@implementation FKRouter

- (void)setFlutterViewContainer:(FBFlutterViewContainer *)flutterViewContainer{
    _flutterViewContainer = flutterViewContainer;
    if (_flutterViewContainer == nil){
        [GeneratedPluginRegistrant registerWithRegistry:_flutterViewContainer];
    }
}

+ (FKRouter *)shared{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        route = [[FKRouter alloc] init];
    });
    return route;
}

- (NSMutableDictionary *)resultTable{
    if (_resultTable == nil){
        _resultTable = [NSMutableDictionary dictionary];
    }
    return _resultTable;
}

- (void)pushFlutterRoute:(FlutterBoostRouteOptions *)options{

    self.flutterViewContainer = [[FBFlutterViewContainer alloc] init];
    [self.flutterViewContainer setName:options.pageName uniqueId:options.uniqueId params:options.arguments opaque:options.opaque];

    //对这个页面设置结果
    [self.resultTable setValue:options.onPageFinished forKey:options.pageName];

    self.flutterViewContainer.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    self.flutterViewContainer.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [[FKRouter currentVC] presentViewController:self.flutterViewContainer animated:true completion:^{
        
    }];
}

- (void)popRoute:(FlutterBoostRouteOptions *)options{
    
    [self.flutterViewContainer dismissViewControllerAnimated:true completion:^{
        
    }];

    //否则直接执行pop逻辑
    //这里在pop的时候将参数带出,并且从结果表中移除
    BoostonPageFinished onPageFinshed = self.resultTable[options.pageName];
    if (onPageFinshed){
        onPageFinshed(options.arguments);
        [self.resultTable removeObjectForKey:options.pageName];
    }
}

- (void)pushNativeRoute:(NSString *)pageName arguments:(NSDictionary *)arguments {
    
}


+ (UIViewController *)currentVC{
    UIViewController *rootvc = [[UIApplication sharedApplication] delegate].window.rootViewController;
    UIViewController *vc = [FKRouter vcWithRootVC:rootvc];
    return vc;
}

+ (UIViewController *)vcWithRootVC:(UIViewController *)vc{
    UIViewController *currentVC = nil;
    UIViewController *rootVC = vc.presentedViewController;
    if (rootVC == nil) {
        return vc;
    }
    
    if ([rootVC isKindOfClass:[UITabBarController class]]) {
        
        UITabBarController *tvc = (UITabBarController *)rootVC;
        currentVC = [FKRouter vcWithRootVC:tvc.selectedViewController];
    }else if ([rootVC isKindOfClass:[UINavigationController class]]){
        
        UINavigationController *nvc = (UINavigationController *)rootVC;
        currentVC = [FKRouter vcWithRootVC:nvc.visibleViewController];
    }else{
        
        currentVC = [FKRouter vcWithRootVC:rootVC];
    }
    
    return currentVC;
}

@end
