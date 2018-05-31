//
//  FeedApi.m
//  ImagesFeedTest
//
//  Created by Aleksey Kiselev on 5/31/18.
//  Copyright © 2018 rf10. All rights reserved.
//

#import "FeedApi.h"
#import "DeviantArtProvider.h"

@implementation FeedApi

static id<FeedProviderProtocol> _provider = nil;

+ (id<FeedProviderProtocol>)provider {
    return _provider;
}

+ (void)setup:(id<FeedProviderProtocol>)provider {
    _provider = provider;
}

@end
