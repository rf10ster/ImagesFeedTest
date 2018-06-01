//
//  AdsCollectionViewCell.m
//  ImagesFeedTest
//
//  Created by Aleksey Kiselev on 6/1/18.
//  Copyright © 2018 rf10. All rights reserved.
//

#import "AdsCollectionViewCell.h"

@implementation AdsCollectionViewCell
- (void)updateWith:(id<FeedItem>)item {
    if ([item isKindOfClass:[FeedAdsModel class]]) {
        FeedAdsModel *model = (FeedAdsModel *)item;
        self.adsLabel.text = model.adsText;
        return;
    }
    self.adsLabel.text = @"Wrong item";
}
@end
