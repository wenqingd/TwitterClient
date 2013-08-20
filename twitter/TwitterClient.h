//
//  TwitterClient.h
//  twitter
//
//  Created by Timothy Lee on 8/5/13.
//  Modified by Wenqing Dai on 8/17/2013
//  Copyright (c) 2013 codepath. All rights reserved.
//

#import "AFOAuth1Client.h"

@interface TwitterClient : AFOAuth1Client

+ (TwitterClient *)instance;

// Users API

- (void)authorizeWithCallbackUrl:(NSURL *)callbackUrl success:(void (^)(AFOAuth1Token *accessToken, id responseObject))success failure:(void (^)(NSError *error))failure;

- (void)currentUserWithSuccess:(void (^)(AFHTTPRequestOperation *operation, id response))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

// Statuses API

- (void)homeTimelineWithCount:(int)count sinceId:(int)sinceId maxId:(int)maxId success:(void (^)(AFHTTPRequestOperation *operation, id response))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

// Tweet API
- (void)postTweetWithText:(NSString *)text success:(void (^)(AFHTTPRequestOperation *operation, id response))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

@end
