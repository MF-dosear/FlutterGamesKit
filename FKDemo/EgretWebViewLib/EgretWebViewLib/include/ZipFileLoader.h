#import <Foundation/Foundation.h>
#import "BaseFileLoader.h"
#import "HttpRequestDownloadProtocol.h"

@interface ZipFileLoader : BaseFileLoader<NSURLSessionDelegate, HttpRequestDownloadProtocol>

- (instancetype)initWithZipUrl:(NSString*)zipUrl TargetDir:(NSString*)targetDir Delegate:(id)delegate;
- (instancetype)initWithZipPath:(NSString*)zipPath Host:(NSString*)host TargetDir:(NSString*)targetDir Delegate:(id)delegate;
- (void)start;

@end
