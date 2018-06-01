//
//  FeedAdsModel.h
//  ImagesFeedTest
//
//  Created by Aleksey Kiselev on 5/31/18.
//  Copyright © 2018 rf10. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FeedItem.h"

@interface FeedAdsModel : NSObject<FeedItem>

- (instancetype)initWithText:(NSString *)adsText;

@property (nonatomic, readonly, strong) NSString *adsText;

@end
