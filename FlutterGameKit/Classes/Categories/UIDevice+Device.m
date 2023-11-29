//
//  UIDevice+Device.m
//  Runner
//
//  Created by Paul on 2023/1/15.
//

#import "UIDevice+Device.h"

#import <sys/utsname.h>
#include <sys/sysctl.h>

#import <AdSupport/AdSupport.h>
#import <AppTrackingTransparency/AppTrackingTransparency.h>

NSString * const kUUIDKey = @"dosear.flutter.uuid";

@implementation UIDevice (Device)

+ (NSString *)uuidWithKeychain{
    
    if (@available(iOS 11.0, *)){
        
        //删除存储在钥匙串中的值，用于调试
        
        // 1.直接从keychain中获取UUID
        NSString *uuidKeychain = [UIDevice load:kUUIDKey];
//        NSLog(@"从keychain中获取UUID%@", uuidKeychain);
        
        // 2.如果获取不到，需要生成UUID并存入系统中的keychain
        if ([uuidKeychain isKindOfClass:[NSNull class]] || uuidKeychain.length == 0) {
            //获取idfa
            NSString *uuid = [[UIDevice currentDevice] identifierForVendor].UUIDString;
            //如果可以获取广告标识符，则获取标识符
            if (uuid && ![uuid isEqualToString:@"00000000-0000-0000-0000-000000000000"]){
                
                [UIDevice save:kUUIDKey data:uuid];
            } else {
                
                // 2.1 生成UUID
                CFUUIDRef puuid = CFUUIDCreate(nil);
                CFStringRef uuidString = CFUUIDCreateString(nil, puuid);
                NSString *result = (NSString *)CFBridgingRelease(CFStringCreateCopy(NULL, uuidString));
                CFRelease(puuid);
                CFRelease(uuidString);
//                NSLog(@"生成UUID：%@",result);
                // 2.2 将生成的UUID保存到keychain中
                [UIDevice save:kUUIDKey data:result];
            }
            // 2.3 从keychain中获取UUID
            uuidKeychain = [UIDevice load:kUUIDKey];
        }
        
        return uuidKeychain;
    } else {
        NSString *uuid = [[UIDevice currentDevice] identifierForVendor].UUIDString;
        return uuid;
    }
    
}


#pragma mark - 删除存储在keychain中的UUID

+ (void)deleteKeyChain {
    [self delete:kUUIDKey];
}


#pragma mark - 私有方法

+ (NSMutableDictionary *)getKeyChainQuery:(NSString *)service {
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:(id)kSecClassGenericPassword,(id)kSecClass,service,(id)kSecAttrService,service,(id)kSecAttrAccount,(id)kSecAttrAccessibleAfterFirstUnlock,(id)kSecAttrAccessible, nil];
}

// 从keychain中获取UUID
+ (NSString *)load:(NSString *)service {
    id ret = nil;
    NSMutableDictionary *keychainQuery = [self getKeyChainQuery:service];
    [keychainQuery setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];
    [keychainQuery setObject:(id)kSecMatchLimitOne forKey:(id)kSecMatchLimit];
    CFDataRef keyData = NULL;
    if (SecItemCopyMatching((CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData) == noErr) {
        @try {
            if (@available(iOS 11.0, *)){
                ret = [NSKeyedUnarchiver unarchivedObjectOfClass:[NSString class] fromData:(__bridge NSData *)keyData error:nil];
            }
        }
        @catch (NSException *exception) {
            NSLog(@"Unarchive of %@ failed: %@", service, exception);
        }
        @finally {
            NSLog(@"finally");
        }
    }
    
    if (keyData) {
        CFRelease(keyData);
    }
//    NSLog(@"ret = %@", ret);
    return ret;
}

+ (void)delete:(NSString *)service {
    NSMutableDictionary *keychainQuery = [self getKeyChainQuery:service];
    SecItemDelete((CFDictionaryRef)keychainQuery);
}

// 将生成的UUID保存到keychain中
+ (void)save:(NSString *)service data:(id)data {
    // Get search dictionary
    NSMutableDictionary *keychainQuery = [self getKeyChainQuery:service];
    // Delete old item before add new item
    SecItemDelete((CFDictionaryRef)keychainQuery);
    // Add new object to search dictionary(Attention:the data format)
    
    if (@available(iOS 11.0, *)) {
        NSData *archiver = [NSKeyedArchiver archivedDataWithRootObject:data requiringSecureCoding:true error:nil];
        
        [keychainQuery setObject:archiver forKey:(id)kSecValueData];
        // Add item to keychain with the search dictionary
        SecItemAdd((CFDictionaryRef)keychainQuery, NULL);
    }
}

+ (NSString *)idfa{
    
    if (@available(iOS 14, *)) {
        
        __block NSString *idfa = [UIDevice uuidWithKeychain];
        [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
            
            if (status == ATTrackingManagerAuthorizationStatusAuthorized) {
                idfa = [ASIdentifierManager.sharedManager advertisingIdentifier].UUIDString;
            } else {
                idfa = [NSString stringWithFormat:@"V:%@",idfa];
            }
        }];
        
        return idfa;
    } else {
        if ([ASIdentifierManager.sharedManager isAdvertisingTrackingEnabled]) {
            
            return [ASIdentifierManager.sharedManager advertisingIdentifier].UUIDString;
        } else {
            return [NSString stringWithFormat:@"V:%@",[UIDevice uuidWithKeychain]];
        }
    }
}

+ (NSString *)modelName{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4 (A1332)";
       if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4 (A1332)";
       if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4 (A1349)";
       if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4s (A1387/A1431)";
       if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5 (A1428)";
       if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5 (A1429/A1442)";
       if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c (A1456/A1532)";
       if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c (A1507/A1516/A1526/A1529)";
       if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s (A1453/A1533)";
       if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s (A1457/A1518/A1528/A1530)";
       if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus (A1522/A1524)";
       if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6 (A1549/A1586)";
       if ([platform isEqualToString:@"iPhone8,1"]) return @"iPhone 6s";
       if ([platform isEqualToString:@"iPhone8,2"]) return @"iPhone 6s Plus";
       if ([platform isEqualToString:@"iPhone9,1"]) return @"iPhone 7 (Global)";
       if ([platform isEqualToString:@"iPhone9,3"]) return @"iPhone 7 (GSM)";
       if ([platform isEqualToString:@"iPhone9,2"]) return @"iPhone 7 Plus (Global)";
       if ([platform isEqualToString:@"iPhone9,4"]) return @"iPhone 7 Plus (GSM)";
       if ([platform isEqualToString:@"iPhone10,1"]) return @"iPhone 8 (Global)";
       if ([platform isEqualToString:@"iPhone10,4"]) return @"iPhone 8 (GSM)";
       if ([platform isEqualToString:@"iPhone10,2"]) return @"iPhone 8 Plus (Global)";
       if ([platform isEqualToString:@"iPhone10,5"]) return @"iPhone 8 Plus (GSM)";
       if ([platform isEqualToString:@"iPhone10,3"]) return @"iPhone X (Global)";
       if ([platform isEqualToString:@"iPhone10,6"]) return @"iPhone X (GSM)";
       if ([platform isEqualToString:@"iPhone11,2"]) return @"iPhone XS";
       if ([platform isEqualToString:@"iPhone11,4"]) return @"iPhone XS Max";
       if ([platform isEqualToString:@"iPhone11,6"]) return @"iPhone XS Max";
       if ([platform isEqualToString:@"iPhone11,8"]) return @"iPhone XR";
    
       if ([platform isEqualToString:@"iPhone12,1"]) return @"iPhone 11";
       if ([platform isEqualToString:@"iPhone12,3"]) return @"iPhone 11 Pro";
       if ([platform isEqualToString:@"iPhone12,5"]) return @"iPhone 11 Pro Max";
       if ([platform isEqualToString:@"iPhone12,8"]) return @"iPhone SE 2";
    
       if ([platform isEqualToString:@"iPhone13,1"]) return @"iPhone 12 mini";
       if ([platform isEqualToString:@"iPhone13,2"]) return @"iPhone 12";
       if ([platform isEqualToString:@"iPhone13,3"]) return @"iPhone 12 Pro";
       if ([platform isEqualToString:@"iPhone13,4"]) return @"iPhone 12 Pro Max";
    
        if ([platform isEqualToString:@"iPhone14,4"]) return @"iPhone 13 mini";
        if ([platform isEqualToString:@"iPhone14,5"]) return @"iPhone 13";
        if ([platform isEqualToString:@"iPhone14,2"]) return @"iPhone 13 Pro";
        if ([platform isEqualToString:@"iPhone14,3"]) return @"iPhone 13 Pro Max";
        if ([platform isEqualToString:@"iPhone14,6"]) return @"iPhone SE 3";
    
        if ([platform isEqualToString:@"iPhone14,7"]) return @"iPhone 14";
        if ([platform isEqualToString:@"iPhone14,8"]) return @"iPhone 14 Plus";
        if ([platform isEqualToString:@"iPhone15,2"]) return @"iPhone 14 Pro";
        if ([platform isEqualToString:@"iPhone15,3"]) return @"iPhone 14 Pro Max";
    
       if ([platform isEqualToString:@"iPod1,1"])   return @"iPod Touch 1G (A1213)";
       if ([platform isEqualToString:@"iPod2,1"])   return @"iPod Touch 2G (A1288)";
       if ([platform isEqualToString:@"iPod3,1"])   return @"iPod Touch 3G (A1318)";
       if ([platform isEqualToString:@"iPod4,1"])   return @"iPod Touch 4G (A1367)";
       if ([platform isEqualToString:@"iPod5,1"])   return @"iPod Touch 5G (A1421/A1509)";
       
       if ([platform isEqualToString:@"iPad1,1"])   return @"iPad 1G (A1219/A1337)";
       
       if ([platform isEqualToString:@"iPad2,1"])   return @"iPad 2 (A1395)";
       if ([platform isEqualToString:@"iPad2,2"])   return @"iPad 2 (A1396)";
       if ([platform isEqualToString:@"iPad2,3"])   return @"iPad 2 (A1397)";
       if ([platform isEqualToString:@"iPad2,4"])   return @"iPad 2 (A1395+New Chip)";
       if ([platform isEqualToString:@"iPad2,5"])   return @"iPad Mini 1G (A1432)";
       if ([platform isEqualToString:@"iPad2,6"])   return @"iPad Mini 1G (A1454)";
       if ([platform isEqualToString:@"iPad2,7"])   return @"iPad Mini 1G (A1455)";
       
       if ([platform isEqualToString:@"iPad3,1"])   return @"iPad 3 (A1416)";
       if ([platform isEqualToString:@"iPad3,2"])   return @"iPad 3 (A1403)";
       if ([platform isEqualToString:@"iPad3,3"])   return @"iPad 3 (A1430)";
       if ([platform isEqualToString:@"iPad3,4"])   return @"iPad 4 (A1458)";
       if ([platform isEqualToString:@"iPad3,5"])   return @"iPad 4 (A1459)";
       if ([platform isEqualToString:@"iPad3,6"])   return @"iPad 4 (A1460)";
       
       if ([platform isEqualToString:@"iPad4,1"])   return @"iPad Air (A1474)";
       if ([platform isEqualToString:@"iPad4,2"])   return @"iPad Air (A1475)";
       if ([platform isEqualToString:@"iPad4,3"])   return @"iPad Air (A1476)";
       if ([platform isEqualToString:@"iPad4,4"])   return @"iPad Mini 2G (A1489)";
       if ([platform isEqualToString:@"iPad4,5"])   return @"iPad Mini 2G (A1490)";
       if ([platform isEqualToString:@"iPad4,6"])   return @"iPad Mini 2G (A1491)";
    
       if ([platform isEqualToString:@"iPad5,3"])   return @"iPad Air 2 (A1566)";
       if ([platform isEqualToString:@"iPad5,4"])   return @"iPad Air 2 (A1567)";
    
       if ([platform isEqualToString:@"iPad11,3"])   return @"iPad Air 3 (A2152)";
       if ([platform isEqualToString:@"iPad11,4"])   return @"iPad Air 3 (A2123 A2153 A2154)";
    
       if ([platform isEqualToString:@"iPad13,1"])   return @"iPad Air 4 (A2316)";
       if ([platform isEqualToString:@"iPad13,2"])   return @"iPad Air 4 (A2324 A2325 A2072)";
    
       if ([platform isEqualToString:@"iPad13,16"])   return @"iPad Air 5 (A2588)";
       if ([platform isEqualToString:@"iPad13,17"])   return @"iPad Air 5 (A2589 A2591)";
    
       if ([platform isEqualToString:@"i386"])      return @"iPhone Simulator";
       if ([platform isEqualToString:@"x86_64"])    return @"iPhone Simulator";
    
       return platform;
}

+ (NSString *)brand{
    switch ([UIDevice currentDevice].userInterfaceIdiom) {
        case UIUserInterfaceIdiomPhone:   return @"iPhone";
            break;
        case UIUserInterfaceIdiomPad:     return @"iPad";
            break;
        case UIUserInterfaceIdiomTV:      return @"iTV";
            break;
        case UIUserInterfaceIdiomCarPlay: return @"iCarPlay";
            break;
        default:                          return @"未知设备";
            break;
    }
}

+ (NSString *)model{
    
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *answer = malloc(size); //••设备编码
    sysctlbyname("hw.machine", answer, &size, NULL, 0);
    NSString *results = [NSString stringWithCString:answer encoding: NSUTF8StringEncoding];
    free(answer);
    return results;
}

static time_t bootSecTime(void){
    
    struct timeval boottime;
    size_t len = sizeof(boottime);
    int mib[2] = { CTL_KERN, KERN_BOOTTIME};
    
    if( sysctl(mib, 2, &boottime, &len, NULL, 0) < 0) {
        return 0;
    }
    return boottime.tv_sec;
}

+ (NSString *)bootTimeInSec {
    return [NSString stringWithFormat:@"%ld",bootSecTime()];
}

+ (NSString *)countryCode{
    NSLocale *locale = [NSLocale currentLocale];
    NSString *countryCode = [locale objectForKey:NSLocaleCountryCode];
    return countryCode;
}

+ (NSString *)language {
    
    NSString *language;
    NSLocale *locale = [NSLocale currentLocale];
    if ([[NSLocale preferredLanguages] count] > 0) {
        language = [[NSLocale preferredLanguages] objectAtIndex:0];
    } else {
        language = [locale objectForKey:NSLocaleLanguageCode]; }
    return language;
}

+ (NSString *)systemVersion {
    return [[UIDevice currentDevice] systemVersion];
}

+(NSString *)machine {
    
    NSString *machine = getSystemHardwareByName(SIDFAMachine);
    return machine == nil ? @"" : machine;
}

static const char *SIDFAMachine = "hw.machine";
static NSString *getSystemHardwareByName(const char *typeSpecifier) {
    size_t size;
    sysctlbyname(typeSpecifier, NULL, &size, NULL, 0);
    char *answer = malloc(size);
    sysctlbyname(typeSpecifier, answer, &size, NULL,0);
    NSString *results = [NSString stringWithUTF8String:answer];
    free(answer);
    return results;
}

+ (NSString *)memory{
    return [NSString stringWithFormat:@"%lld", [NSProcessInfo processInfo].physicalMemory];
}

+ (NSString *)disk {
    int64_t space = -1;
    NSError *error = nil;
    NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:&error];
    
    if (!error) {
        space = [[attrs objectForKey:NSFileSystemSize] longLongValue];
    }
    if(space < 0) {
        space = -1;
    }
    return [NSString stringWithFormat:@"%lld",space];
}

+ (NSString *)sysFileTime {
    
    NSString *result = nil;
    NSString *information = @"L3Zhci9tb2JpbGUvTGlicmFyeS9Vc2VyQ29uZmlndXJhdGlvblByb2ZpbGVzL1B1YmxpY0luZm8vTUNNZXRhLnBsaXN0";
    NSData *data=[[NSData alloc] initWithBase64EncodedString:information options:0] ;
    NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:dataString error:&error];
    if (fileAttributes) {
        id singleAttibute = [fileAttributes objectForKey:NSFileCreationDate];
        if ([singleAttibute isKindOfClass:[NSDate class]]) {
            NSDate *dataDate = singleAttibute;
            result = [NSString stringWithFormat:@"%f",[dataDate timeIntervalSince1970]];
        }
    }
    return result;
}

static const char *SIDFAModel = "hw.model";
+ (NSString *)model_CAID{
    NSString *model = getSystemHardwareByName(SIDFAModel);
    return model == nil ? @"" : model;
}

+ (NSString *)timeZone {
    NSInteger offset = [NSTimeZone systemTimeZone].secondsFromGMT;
    return [NSString stringWithFormat:@"%ld",(long)offset];
}

@end
