//
//  FeedItemCollectionViewCell.h
//  ImagesFeedTest
//
//  Created by Aleksey Kiselev on 6/1/18.
//  Copyright © 2018 rf10. All rights reserved.
//


#import "FeedItemModel.h"
#import "BaseCollectionViewCell.h"

@interface FeedItemCollectionViewCell : BaseCollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityView;

@end
