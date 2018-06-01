//
//  ImagesFeedCollectionViewLayout.m
//  ImagesFeedTest
//
//  Created by Aleksey Kiselev on 6/1/18.
//  Copyright © 2018 rf10. All rights reserved.
//

#import "ImagesFeedCollectionViewLayout.h"

@interface ImagesFeedCollectionViewLayout ()
    @property (nonatomic, strong) NSMutableArray<UICollectionViewLayoutAttributes *> *cache;
    @property (nonatomic, assign) CGFloat contentHeight;
    
@end

@implementation ImagesFeedCollectionViewLayout
    
    - (CGFloat)contentWidth {
        return self.collectionView.bounds.size.width - (self.collectionView.contentInset.left + self.collectionView.contentInset.right);
    }
    
    - (CGSize)collectionViewContentSize {
        return CGSizeMake(self.contentWidth, self.contentHeight);
    }
    
- (void)prepareLayout {
    self.cache = [NSMutableArray array];
    self.contentHeight = 0;
    CGFloat columnWidth = self.contentWidth / self.numberOfColumns;
    NSMutableArray *xOffset = [NSMutableArray array];
    NSMutableArray *yOffset = [NSMutableArray array];
    for (NSInteger column = 0; column < self.numberOfColumns; column++) {
        [xOffset addObject:[NSNumber numberWithFloat:(column * columnWidth)]];
        [yOffset addObject:@0];
    }
    NSInteger column = 0;
    NSInteger currentSection = 0;
    NSInteger items = [self.collectionView numberOfItemsInSection:currentSection];
    for (NSInteger item = 0; item < items; item++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:currentSection];
        // Check columnWidth-self.cellPadding or just self.cellPadding
        CGSize itemSize = [self.delegate collectionView:self.collectionView sizeForItemAt:indexPath constraints:CGSizeMake(columnWidth-self.cellPadding, 999)];
        
        CGFloat height = self.cellPadding * 2 + itemSize.height;
        CGRect frame = CGRectMake([xOffset[column] floatValue], [yOffset[column] floatValue], columnWidth, height);
        
        
        UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        attributes.frame = CGRectInset(frame, self.cellPadding, self.cellPadding);
        [self.cache addObject:attributes];
        

        CGFloat maxY = (frame.origin.y + frame.size.height);
        self.contentHeight = self.contentHeight > maxY ? self.contentHeight : maxY;
        yOffset[column] = @([yOffset[column] floatValue] + height);
        
        column = column < (self.numberOfColumns - 1) ? (column + 1) : 0;
    }
}
    
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray<UICollectionViewLayoutAttributes *> *visibleLayoutAttributes = [NSMutableArray array];
    for (UICollectionViewLayoutAttributes *attributes in self.cache) {
        if (CGRectIntersectsRect(attributes.frame, rect)) {
            [visibleLayoutAttributes addObject:attributes];
        }
    }
    return visibleLayoutAttributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.cache[indexPath.item];
}

@end
