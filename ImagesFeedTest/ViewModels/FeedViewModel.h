//
//  FeedViewModel.h
//  ImagesFeedTest
//
//  Created by Aleksey Kiselev on 6/1/18.
//  Copyright © 2018 rf10. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FeedItem.h"

@protocol FeedViewModelDelegate <NSObject>
- (void)viewModelDidChangeColumns:(NSInteger)columns;
- (void)viewModelDidAddItems:(NSArray<id<FeedItem>> *)items isInitial:(BOOL)isInitial;
@end

@interface FeedViewModel : NSObject

- (instancetype)initWithMaxColumns:(NSInteger)maxColumns
                        minColumns:(NSInteger)minColumns
                           columns:(NSInteger)columns;

@property(nonatomic, weak) id <FeedViewModelDelegate> delegate;

@property(nonatomic, assign, readonly) NSInteger minColumnsCount;
@property(nonatomic, assign, readonly) NSInteger maxColumnsCount;
@property(nonatomic, assign, readonly) NSInteger currentColumnsCount;

@property(nonatomic, assign, readonly) NSInteger sections;

@property(nonatomic,assign) BOOL hasMore;
@property(nonatomic,assign) NSInteger nextOffset;

- (NSArray<id<FeedItem>> *)items;
- (void)addItems:(NSArray<id<FeedItem>> *)newItems;
- (void)addColumn;
- (void)removeColumn;

- (id<FeedItem>)itemFor:(NSIndexPath *)indexPath;
- (CGSize)itemSizeFor:(NSIndexPath *)indexPath constrants:(CGSize)constraints;

@end
