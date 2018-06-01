//
//  AdsCollectionViewCell.h
//  ImagesFeedTest
//
//  Created by Aleksey Kiselev on 6/1/18.
//  Copyright © 2018 rf10. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FeedAdsModel.h"
#import "BaseCollectionViewCell.h"

@interface AdsCollectionViewCell : BaseCollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *adsLabel;

@end
