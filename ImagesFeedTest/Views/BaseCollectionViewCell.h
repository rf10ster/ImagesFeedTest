//
//  BaseCollectionViewCell.h
//  ImagesFeedTest
//
//  Created by Aleksey Kiselev on 6/1/18.
//  Copyright © 2018 rf10. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FeedItem.h"

@interface BaseCollectionViewCell: UICollectionViewCell
- (void)updateWith:(id<FeedItem>)item;
@end
