//
//  FeedItemCollectionViewCell.m
//  ImagesFeedTest
//
//  Created by Aleksey Kiselev on 6/1/18.
//  Copyright © 2018 rf10. All rights reserved.
//

#import "FeedItemCollectionViewCell.h"
@import SDWebImage;

@implementation FeedItemCollectionViewCell

- (void)updateWith:(id<FeedItem>)item {
    if ([item isKindOfClass:[FeedItemModel class]]) {
        FeedItemModel *model = (FeedItemModel *)item;
        __weak typeof(self)weakSelf = self;
        [self.imageView sd_setImageWithURL:model.imageUrl completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            [weakSelf.activityView stopAnimating];
        }];
        return;
    }
    self.imageView.image = nil;
    [self.activityView stopAnimating];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    [self stopLoading];
}

// MARK: - helper method

- (void)stopLoading {
    [self.imageView sd_cancelCurrentImageLoad];
    [self.activityView startAnimating];
    self.imageView.image = nil;
}

@end
