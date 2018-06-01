//
//  DeviantArtProvider.m
//  ImagesFeedTest
//
//  Created by Aleksey Kiselev on 5/31/18.
//  Copyright © 2018 rf10. All rights reserved.
//
// ref: https://www.deviantart.com/developers/http/v1/20160316/browse_popular/73900c76a9806d17d78956830797d15d

#import "DeviantArtProvider.h"
@import AFNetworking;

// This can be injected as parameters, but for simplicity here as constants
NSString * const DeviantArtBaseURL = @"https://www.deviantart.com";
NSString * const DeviantArtPopularEndpoint = @"/api/v1/oauth2/browse/popular";
NSString * const DeviantArtTokenPath = @"/oauth2/token";
NSInteger const DeviantArtFetchLimit = 20; //min: 1 max: 120 default: 10
// credentials
NSString * const client_id = @"8143";
NSString * const client_secret = @"772981ffe669885ff2f9d08af17ce1b3";
NSString * const grant_type = @"client_credentials";
NSString * const access_token = @"access_token";

// imagesfeedtest://oauth2/deviantart

@interface DeviantArtProvider ()

@property (nonatomic, assign) NSInteger fetchLimit;
@property (nonatomic, strong) AFHTTPSessionManager *httpClient;

@end

@implementation DeviantArtProvider

- (instancetype)init {
    if (self = [super init]) {
        NSURL *baseURL = [NSURL URLWithString:DeviantArtBaseURL];
        self.fetchLimit = DeviantArtFetchLimit;
        
        self.httpClient = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
        self.httpClient.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    }
    return self;
}



- (void)fetchWithOffset:(NSInteger)offset onSuccess:(void (^)(FetchResult *result))successBlock onFailure:(void (^)(NSError * error))failureBlock {

    [self performRequest:[self popularRequest:offset] retryOnNotAuthorized:YES success:^(NSDictionary *jsonItems) {
        
    } failure:^(NSURLSessionDataTask *dataTask, NSError *error) {
        failureBlock(error);
    }];
}


// MARK: - helper methods

- (NSURLRequest *)popularRequest:(NSInteger)offset {
    NSDictionary *params = @{ @"offset" : @(offset), @"limit" : @(DeviantArtFetchLimit) };
    return [self requestWithMethod:@"GET" URLString:DeviantArtPopularEndpoint parameters:params];
}

- (NSURLRequest *)tokenRequest {
    NSDictionary *params = @{
                             @"client_id" : client_id,
                             @"client_secret" : client_secret,
                             @"grant_type" : grant_type
                             };
    return [self requestWithMethod:@"GET" URLString:DeviantArtTokenPath parameters:params];
}

- (NSURLRequest *)requestWithMethod:(NSString *)method URLString:(NSString *)URLString parameters:(id)parameters  {
    
    NSString *accessToken = [[NSUserDefaults standardUserDefaults] stringForKey:access_token];
    if (accessToken) {
        [self.httpClient.requestSerializer setValue:accessToken forHTTPHeaderField:@"Authorization"];
    }
    
    return [self.httpClient.requestSerializer requestWithMethod:method URLString:[[NSURL URLWithString:URLString relativeToURL:self.httpClient.baseURL] absoluteString] parameters:parameters error:nil];
}

- (NSURLSessionDataTask *)performRequest:(NSURLRequest *)request retryOnNotAuthorized:(BOOL)retryOnNotAuthorized success:(void (^)(id))success failure:(void (^)(NSURLSessionDataTask *dataTask, NSError *error))failure {
    NSParameterAssert(success);
    __weak typeof(self)weakSelf = self;
    __block NSURLSessionDataTask *dataTask = nil;
    dataTask = [self.httpClient dataTaskWithRequest:request
                                     uploadProgress:nil
                                   downloadProgress:nil
                                  completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                                      if (!error) {
                                          NSDictionary *jsonDictionary = nil;
                                          jsonDictionary = responseObject;
                                          dispatch_async(dispatch_get_main_queue(), ^{
                                              success(jsonDictionary);
                                          });
                                      } else {
                                          if ([weakSelf isNotAuthorized:response responseObject:responseObject error:error] && retryOnNotAuthorized) {
                                              // not authorized
                                              [weakSelf reloginWith:dataTask success:success failure:failure];
                                          } else if (failure) {
                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                  failure(dataTask, error);
                                              });
                                          }
                                      }
                                  }];
    
    [dataTask resume];
    return dataTask;
}

- (void)reloginWith:(NSURLSessionDataTask *)originalDataTask success:(void (^)(id))success failure:(void (^)(NSURLSessionDataTask *dataTask, NSError *error))failure {
    __weak typeof(self)weakSelf = self;
    [self performRequest:[self tokenRequest] retryOnNotAuthorized:NO success:^(NSDictionary *jsonItems) {
        NSString *accessToken = jsonItems[access_token];
        [[NSUserDefaults standardUserDefaults] setObject:accessToken forKey:access_token];
        // recreate request
        NSMutableURLRequest *mutableRequest = [originalDataTask.originalRequest mutableCopy];
        [mutableRequest addValue:accessToken forHTTPHeaderField:@"Authorization"];
        [[weakSelf performRequest:[mutableRequest copy] retryOnNotAuthorized:NO success:success failure:failure] resume];
        if (originalDataTask.state != NSURLSessionTaskStateCanceling) {
            [originalDataTask cancel];
        }
    } failure:^(NSURLSessionDataTask *dataTask, NSError *error) {
        failure(originalDataTask, error);
        if (originalDataTask.state != NSURLSessionTaskStateCanceling) {
            [originalDataTask cancel];
        }
    }];
}

- (BOOL)isNotAuthorized:(NSURLResponse *)response responseObject:(id)responseObject error:(NSError *)error {
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
    if (httpResponse.statusCode == 401) {
        NSLog(@"response is not authorized %@", response);
        return YES;
    }
    return NO;
}
@end
