//
//  FetchResult.h
//  ImagesFeedTest
//
//  Created by Aleksey Kiselev on 6/1/18.
//  Copyright © 2018 rf10. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FeedItemModel.h"

/*
 
 has_more (boolean)
 next_offset (integer|null)
 estimated_total (integer) Optional
 Only available for search queries
 results (array [deviation object])
 
 */

@interface FetchResult : NSObject
@property(nonatomic,assign) BOOL hasMore;
@property(nonatomic,assign) NSInteger nextOffset;
@property(nonatomic,strong) NSArray<__kindof FeedItemModel *> *feedItems;
@end
