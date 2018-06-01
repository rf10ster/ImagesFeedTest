//
//  FeedViewModel.m
//  ImagesFeedTest
//
//  Created by Aleksey Kiselev on 6/1/18.
//  Copyright © 2018 rf10. All rights reserved.
//

#import "FeedViewModel.h"

@interface FeedViewModel ()
@property(nonatomic, strong, readwrite) NSMutableArray<id<FeedItem>> *items;
@end

@implementation FeedViewModel

- (instancetype)initWithMaxColumns:(NSInteger)maxColumns minColumns:(NSInteger)minColumns columns:(NSInteger)columns {
    if (self = [super init]) {
        _currentColumnsCount = columns;
        _minColumnsCount = minColumns;
        _maxColumnsCount = maxColumns;
        
        // there will be only one section
        _sections = 1;
    }
    return self;
}

- (void)addColumn {
    _currentColumnsCount ++;
    if (_currentColumnsCount > _maxColumnsCount) {
        _currentColumnsCount = _maxColumnsCount;
    } else {
        [self.delegate viewModelDidChangeColumns:_currentColumnsCount];
    }
}

- (void)removeColumn {
    _currentColumnsCount --;
    if (_minColumnsCount > _currentColumnsCount) {
        _currentColumnsCount = _minColumnsCount;
    } else {
        [self.delegate viewModelDidChangeColumns:_currentColumnsCount];
    }
}

- (void)addItems:(NSArray<id<FeedItem>> *)newItems {
    BOOL isInitial = self.items.count == 0;
    if (isInitial) {
        _items = [NSMutableArray arrayWithCapacity:newItems.count];
    }
    [_items addObjectsFromArray:newItems];
    [self.delegate viewModelDidAddItems:newItems isInitial:isInitial];
}

- (id<FeedItem>)itemFor:(NSIndexPath *)indexPath {
    if (indexPath.section > (self.sections - 1)) {
        return nil;
    }
    if (indexPath.row > (self.items.count - 1)) {
        return nil;
    }
    return self.items[indexPath.row];
}

- (CGSize)itemSizeFor:(NSIndexPath *)indexPath constrants:(CGSize)constraints {
    return CGSizeMake(constraints.width, constraints.width);
}

@end
