//
//  ImagesFeedCollectionViewLayout.h
//  ImagesFeedTest
//
//  Created by Aleksey Kiselev on 6/1/18.
//  Copyright © 2018 rf10. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ImagesFeedCollectionViewLayoutDelegate <NSObject>
- (CGSize)collectionView:(UICollectionView *)collectionView sizeForItemAt:(NSIndexPath *)IndexPath constraints:(CGSize)constraints;
@end

@interface ImagesFeedCollectionViewLayout : UICollectionViewLayout
@property(nonatomic, assign) NSInteger numberOfColumns;
@property(nonatomic, assign) CGFloat cellPadding;
@property(nonatomic, weak) id<ImagesFeedCollectionViewLayoutDelegate> delegate;
@end
