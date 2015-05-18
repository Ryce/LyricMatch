//
//  LyricSession.h
//  LyrixMatch
//
//  Created by Hamon Riazy on 03/04/15.
//  Copyright (c) 2015 riazy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LyricSession : NSObject

/**
Initializes a new shared session ivar

@return the shared session object

*/

+ (instancetype)sharedSession;

/**
Triggers a search for the given parameters. Cancels previous requests if these have not finished in time

@param query        The lyric which should be searched for
@param completion   completion block that either returns an array with the resulting songs or an error which occurred

*/

- (void)searchLyric:(NSString *)query completion:(void (^)(NSArray *results, NSError *error))completion;

@end

NS_ASSUME_NONNULL_END
