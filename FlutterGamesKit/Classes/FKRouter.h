//
//  Router.h
//  unit
//
//  Created by Paul on 2023/1/10.
//

#import <Foundation/Foundation.h>
#import <flutter_boost/FlutterBoost.h>

NS_ASSUME_NONNULL_BEGIN

@interface FKRouter : NSObject<FlutterBoostDelegate>

//@property (nonatomic, strong) UINavigationController *navigationController;

@property (nonatomic, strong) FBFlutterViewContainer *flutterViewContainer;

+ (FKRouter *)shared;

+ (UIViewController *)currentVC;

@end

NS_ASSUME_NONNULL_END
