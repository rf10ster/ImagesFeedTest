//
//  FeedProviderProtocol.h
//  ImagesFeedTest
//
//  Created by Aleksey Kiselev on 5/31/18.
//  Copyright © 2018 rf10. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FetchResult.h"

@protocol FeedProviderProtocol <NSObject>

- (void)fetchWithOffset:(NSInteger)offset onSuccess:(void (^)(FetchResult *result))successBlock onFailure:(void (^)(NSError * error))failureBlock;

@end
