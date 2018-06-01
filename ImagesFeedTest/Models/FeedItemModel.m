//
//  FeedItemModel.m
//  ImagesFeedTest
//
//  Created by Aleksey Kiselev on 5/31/18.
//  Copyright © 2018 rf10. All rights reserved.
//

#import "FeedItemModel.h"
@import Foundation;

@implementation FeedItemModel

- (instancetype)initWithUrl:(NSURL *)imageUrl size:(CGSize)imageSize {
    self = [super init];
    if (self) {
        _imageUrl = imageUrl;
        _imageSize = imageSize;
    }
    return self;
}

- (FeedItemType)itemType {
    return FeedItemTypeFeed;
}

@end
