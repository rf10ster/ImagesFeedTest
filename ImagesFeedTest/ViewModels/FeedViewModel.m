//
//  FeedViewModel.m
//  ImagesFeedTest
//
//  Created by Aleksey Kiselev on 6/1/18.
//  Copyright © 2018 rf10. All rights reserved.
//

#import "FeedViewModel.h"

@interface FeedViewModel ()
@property(nonatomic, strong, readwrite) NSArray<id<FeedItem>> *items;
@property (nonatomic, strong) dispatch_queue_t serialQueue;
@property(nonatomic, assign, readwrite) NSInteger currentColumnsCount;
@end

@implementation FeedViewModel

- (instancetype)initWithMaxColumns:(NSInteger)maxColumns minColumns:(NSInteger)minColumns columns:(NSInteger)columns {
    if (self = [super init]) {
        _currentColumnsCount = columns;
        _minColumnsCount = minColumns;
        _maxColumnsCount = maxColumns;
        
        // there will be only one section
        _sections = 1;
        
        _serialQueue = dispatch_queue_create("com.rf10ster.feedviewmodelqueue", DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

- (void)addColumn {
    __weak typeof(self)weakSelf = self;
    dispatch_async(self.serialQueue, ^{
        weakSelf.currentColumnsCount ++;
        if (weakSelf.currentColumnsCount > weakSelf.maxColumnsCount) {
            weakSelf.currentColumnsCount = weakSelf.maxColumnsCount;
        } else {
            
            dispatch_semaphore_t sema = dispatch_semaphore_create(0);
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.delegate viewModelDidChangeColumns:weakSelf.currentColumnsCount completed:^{
                    dispatch_semaphore_signal(sema);
                }];
            });
            dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
            
        }
    });
}

- (void)removeColumn {
    __weak typeof(self)weakSelf = self;
    dispatch_async(self.serialQueue, ^{
        weakSelf.currentColumnsCount --;
        if (weakSelf.minColumnsCount > weakSelf.currentColumnsCount) {
            weakSelf.currentColumnsCount = weakSelf.minColumnsCount;
        } else {
            
            dispatch_semaphore_t sema = dispatch_semaphore_create(0);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate viewModelDidChangeColumns:weakSelf.currentColumnsCount completed:^{
                    dispatch_semaphore_signal(sema);
                }];
            });
            dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
            
        }
    });
}

- (void)addItems:(NSArray<id<FeedItem>> *)newItems {
    __weak typeof(self)weakSelf = self;
    dispatch_async(self.serialQueue, ^{
        NSMutableArray *allItems = [[NSMutableArray alloc] initWithCapacity:(weakSelf.items.count + newItems.count)];
        [allItems addObjectsFromArray:weakSelf.items];
        [allItems addObjectsFromArray:newItems];
        weakSelf.items = allItems;
        NSIndexSet *addedIdxs = [[NSIndexSet alloc] initWithIndexesInRange:NSMakeRange(weakSelf.items.count-newItems.count,newItems.count)];
        
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.delegate viewModelDidAddItemsAt:addedIdxs completed:^{
                dispatch_semaphore_signal(sema);
            }];
        });
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        
    });
}
    
- (void)insertItem:(id<FeedItem>)item withinRange:(NSRange)range {
    __weak typeof(self)weakSelf = self;
    dispatch_async(self.serialQueue, ^{
        NSInteger min = range.location;
        NSInteger max = min + range.length - 1;
        NSInteger currentIndex = min + arc4random_uniform((uint32_t)(max - min + 1));
        NSMutableArray *allItems = [weakSelf.items mutableCopy];
        [allItems insertObject:item atIndex:currentIndex];
        weakSelf.items = allItems;
        
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.delegate viewModelDidAddItemsAt:[NSIndexSet indexSetWithIndex:currentIndex] completed:^{
                dispatch_semaphore_signal(sema);
            }];
        });
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        
    });
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
