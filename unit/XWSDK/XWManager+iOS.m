//
//  XWManager+iOS.m
//  unit
//
//  Created by Paul on 2023/1/10.
//

#import "XWManager+iOS.h"

@implementation XWManager (iOS)

+ (void)sendFlutterMethod:(NSString *)method arguments:(NSDictionary *)arguments{
    FlutterMethodChannel *channel = (FlutterMethodChannel *)[XWManager shared].channel;
    [channel invokeMethod:method arguments:arguments];
}

@end
