//
//  XWManager+iOS.h
//  unit
//
//  Created by Paul on 2023/1/10.
//

#import "XWManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface XWManager (iOS)

+ (void)sendFlutterMethod:(NSString *)method arguments:(NSDictionary *)arguments;

@end

NS_ASSUME_NONNULL_END
