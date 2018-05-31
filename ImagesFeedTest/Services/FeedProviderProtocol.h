//
//  FeedProviderProtocol.h
//  ImagesFeedTest
//
//  Created by Aleksey Kiselev on 5/31/18.
//  Copyright © 2018 rf10. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FeedItemModel.h"

@protocol FeedProviderProtocol <NSObject>

- (void)fetchWithOffset:(NSInteger)offset onSuccess:(void (^)(NSArray<__kindof FeedItemModel *> *results))successBlock onFailure:(void (^)(NSError * error))failureBlock;

@end
