#import <Foundation/Foundation.h>

@class DownloadTask;

@protocol HttpRequestDownloadProtocol <NSObject>

@required
- (void)onSuccess:(DownloadTask*)task;

@required
- (void)onError:(DownloadTask*)task ErrorMsg:(NSString*)errMsg;

@optional
- (void)onProgress:(DownloadTask*)task Loaded:(long long)loaded Total:(long long)total;

@optional
- (bool)onUnZip:(NSString*)zipFilePath DstDir:(NSString*)dstDir Callback:(void(^)(bool))callback;

@end
