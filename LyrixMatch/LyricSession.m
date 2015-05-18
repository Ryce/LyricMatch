//
//  LyricSession.m
//  LyrixMatch
//
//  Created by Hamon Riazy on 03/04/15.
//  Copyright (c) 2015 riazy. All rights reserved.
//

#import "LyricSession.h"
#import <AFNetworking.h>

NSString * const kAPIKey = @"d04de1425c28b16be737bcb13f4df2";

@interface LyricSession ()

@property (nonatomic, strong) AFHTTPRequestOperationManager *manager;

// only one concurrent search operation allowed
@property (nonatomic, weak) AFHTTPRequestOperation *operation;

@end

@implementation LyricSession

#pragma mark - Singleton

+ (instancetype)sharedSession {
  static LyricSession *session;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    session = [LyricSession new];
  });
  return session;
}

#pragma mark - API

- (void)searchLyric:(NSString *)query completion:(void (^)(NSArray *results, NSError *error))completion {
  // no need for synchronized lock because operation is weak
  // cancel previous operations
  if (self.operation) {
    [self.operation cancel];
  }

  NSString *urlString = @"http://api.lyricsnmusic.com/songs";
  NSDictionary *params = @{@"api_key":kAPIKey, @"q": [query stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]};
  self.operation = [self.manager GET:urlString parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
    NSLog(@"response: %@", responseObject);
    if (completion) {
      completion(responseObject, nil);
    }
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    NSLog(@"Error: %@", error);
    if (error.code != NSURLErrorCancelled) {
      if (completion) {
        completion(nil, error);
      }
    }
  }];
}

#pragma mark - Lazy Loading

- (AFHTTPRequestOperationManager *)manager {
  if (_manager == nil) {
    _manager = [AFHTTPRequestOperationManager manager];
    _manager.responseSerializer = [AFJSONResponseSerializer serializer];
  }
  return _manager;
}

@end
