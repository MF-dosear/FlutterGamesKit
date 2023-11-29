//
//  FKSDK+Device.h
//  Runner
//
//  Created by Paul on 2023/1/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIDevice (Device)

+ (NSString *)uuidWithKeychain;

+ (NSString *)idfa;

/// 设备型号
+ (NSString *)modelName;

/// 设备品牌
+ (NSString *)brand;

+ (NSString *)model;

+ (NSString *)bootTimeInSec;

+ (NSString *)countryCode;

+ (NSString *)language;

+ (NSString *)systemVersion;

+ (NSString *)machine;

+ (NSString *)memory;

+ (NSString *)disk;

+ (NSString *)sysFileTime;

+ (NSString *)model_CAID;

+ (NSString *)timeZone;

@end

NS_ASSUME_NONNULL_END
