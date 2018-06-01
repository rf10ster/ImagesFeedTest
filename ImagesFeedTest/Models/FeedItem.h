//
//  FeedItem.h
//  ImagesFeedTest
//
//  Created by Aleksey Kiselev on 6/1/18.
//  Copyright © 2018 rf10. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, FeedItemType) {
    FeedItemTypeFeed,
    FeedItemTypeAds,
};

@protocol FeedItem <NSObject>
- (FeedItemType)itemType;
@end
