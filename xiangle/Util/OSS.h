//
//  OSS.h
//  xiangle
//
//  Created by wei cui on 2020/3/5.
//  Copyright © 2020 wei cui. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OSS : NSObject
+(instancetype)sharedManager;
-(NSString *)uploadJokeImage:(NSString *)path data:(NSData *)data;
-(NSString *)uploadJokeVideo:(NSString *)path data:(NSURL *)url;
@end

NS_ASSUME_NONNULL_END
