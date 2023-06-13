#import <Foundation/Foundation.h>
#import "BaseFileLoader.h"
#import "HttpRequestDownloadProtocol.h"

@interface ListFileLoader : BaseFileLoader<HttpRequestDownloadProtocol>

- (instancetype)initWithJsonUrl:(NSString*)jsonUrl TargetDir:(NSString*)targetDir Delegate:(id)delegate;
- (void)start;

@end
