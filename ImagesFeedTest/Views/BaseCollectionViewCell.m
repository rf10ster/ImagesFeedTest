//
//  BaseCollectionViewCell.m
//  ImagesFeedTest
//
//  Created by Aleksey Kiselev on 6/1/18.
//  Copyright © 2018 rf10. All rights reserved.
//

#import "BaseCollectionViewCell.h"

@implementation BaseCollectionViewCell
- (void)updateWith:(id<FeedItem>)item {
    NSException *e = [NSException
                      exceptionWithName:@"Fatal error"
                      reason:@"BaseCollectionViewCell should not be used"
                      userInfo:nil];
    @throw e;
    
}
@end
