//
//  FetchResult.h
//  ImagesFeedTest
//
//  Created by Aleksey Kiselev on 6/1/18.
//  Copyright © 2018 rf10. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FeedItemModel.h"
@import JSONModel;

/*
 thumbs = array, or
 
 preview (object) Optional
 {
 src (string)
 height (integer)
 width (integer)
 transparency (boolean)
 }
 */
@interface FetchItemResult : JSONModel
@property(nonatomic,strong) NSString *deviationid;
@property(nonatomic,strong) NSString <Optional> *src;
@property(nonatomic,strong) NSNumber <Optional> *height;
@property(nonatomic,strong) NSNumber <Optional> *width;
@property(nonatomic,strong) NSArray <Optional> *thumbs;
@end

/*
 
 has_more (boolean)
 next_offset (integer|null)
 estimated_total (integer) Optional - Only available for search queries
 results (array [deviation object])
 
 */
@interface FetchResult : JSONModel
@property(nonatomic,assign) BOOL hasMore;
@property(nonatomic,assign) NSInteger nextOffset;
@property(nonatomic,strong) NSArray<NSDictionary *> *results;
    
@property(nonatomic,strong, readonly) NSArray<FeedItemModel *> <Ignore> *models;
    
@end


