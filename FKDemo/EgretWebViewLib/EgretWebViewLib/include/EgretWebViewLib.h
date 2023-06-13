#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "FileLoaderProtocol.h"
#import "ListFileLoader.h"
#import "ZipFileLoader.h"

typedef void (^ExternalInterfaceBlock)(NSString*);

@interface EgretWebViewLib : NSObject

+ (void)initialize:(NSString*)preloadPath;
+ (NSString*)getPreloadPathByGameUrl:(NSString*)gameUrl;
+ (bool)checkLoaded:(NSString*)resUrl;
+ (bool)checkLoaded:(NSString*)zipPath Host:(NSString*)host;
+ (long long)getCacheSize;
+ (void)cleanPreloadDir;
+ (ListFileLoader*)createListFileLoader:(NSString*)resUrl Delegate:(id)delegate;
+ (ZipFileLoader*)createZipFileLoader:(NSString*)resUrl Delegate:(id)delegate;
+ (ZipFileLoader*)createZipFileLoader:(NSString*)zipPath Host:(NSString*)host Delegate:(id)delegate;

+ (void)stopAllLoader;
+ (void)destroy;

+ (bool)startLocalServer;
+ (bool)startLocalServerFromResource;
+ (void)startGame:(NSString*)gameUrl SuperView:(UIView*)superView;
+ (void)startGame:(NSString*)gameUrl Host:(NSString*)host SuperView:(UIView*)superView;
+ (void)stopGame;

+ (void)setExternalInterface:(NSString*)funcName Callback:(ExternalInterfaceBlock)block;
+ (void)callExternalInterface:(NSString*)funcName Value:(NSString*)value;

@end
