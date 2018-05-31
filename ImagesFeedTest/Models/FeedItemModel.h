//
//  FeedItemModel.h
//  ImagesFeedTest
//
//  Created by Aleksey Kiselev on 5/31/18.
//  Copyright © 2018 rf10. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreGraphics;

@interface FeedItemModel : NSObject

- (instancetype)initWithUrl:(NSURL *)imageUrl size:(CGSize)imageSize;

@property (nonatomic, readonly, strong) NSURL *imageUrl;
@property (nonatomic, readonly, assign) CGSize imageSize;

@end
