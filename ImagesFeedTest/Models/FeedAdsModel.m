//
//  FeedAdsModel.m
//  ImagesFeedTest
//
//  Created by Aleksey Kiselev on 5/31/18.
//  Copyright © 2018 rf10. All rights reserved.
//

#import "FeedAdsModel.h"

@implementation FeedAdsModel

- (instancetype)initWithText:(NSString *)adsText {
    self = [super init];
    if (self) {
        _adsText = adsText;
    }
    return self;
}

@end
