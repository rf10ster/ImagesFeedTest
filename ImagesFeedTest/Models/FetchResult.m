//
//  FetchResult.m
//  ImagesFeedTest
//
//  Created by Aleksey Kiselev on 6/1/18.
//  Copyright © 2018 rf10. All rights reserved.
//

#import "FetchResult.h"

@implementation FetchItemResult
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
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:
            @{
              @"deviationid" : @"deviationid",
              @"thumbs": @"thumbs",
              @"src": @"preview.src",
              @"height": @"preview.height",
              @"width": @"preview.width",
              }];
}
    
@end

@interface FetchResult ()
    @property (nonatomic, strong) NSArray *models;
@end
@implementation FetchResult

+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    if ([propertyName isEqualToString:@"nextOffset"] || [propertyName isEqualToString:@"next_offset"] || [propertyName isEqualToString:@"models"])
        return YES;
    
    return NO;
}
    
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:
  @{
    
      @"hasMore": @"has_more",
      @"nextOffset": @"next_offset",
      @"results": @"results"
    }];
}
    
- (NSArray<FeedItemModel *> *)models {
    NSMutableArray *items = [[NSMutableArray alloc] initWithCapacity:self.results.count];
    for (NSDictionary *fetchItemJson in self.results) {
        NSError *jsonerror;
        FetchItemResult *r = [[FetchItemResult alloc] initWithDictionary:fetchItemJson error:&jsonerror];
        if (jsonerror) {
            continue;
        }
        
        if (!r.src || !r.width || !r.height) {
            continue;
        }
        CGFloat width = r.width.floatValue;
        CGFloat height = r.height.floatValue;
        NSURL *url = [NSURL URLWithString:r.src];
        FeedItemModel *model = [[FeedItemModel alloc] initWithUrl:url size:CGSizeMake(width, height)];
        [items addObject:model];
    }
    return items;
}
    
@end
