#import <Foundation/Foundation.h>

@protocol FileLoaderProtocol <NSObject>

@required
- (void)onStart:(long)fileCount Size:(long)totalSize;

@required
- (void)onProgress:(NSString*)filePath Loaded:(long)loaded Error:(long)error Total:(long)total;

@required
- (void)onError:(NSString*)urlStr Msg:(NSString*)errMsg;

@required
- (void)onStop;

@required
- (bool)onUnZip:(NSString*)zipFilePath DstDir:(NSString*)dstDir;

@end
