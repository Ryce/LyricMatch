//
//  LyricSessionTests.m
//  LyrixMatch
//
//  Created by Hamon Riazy on 18/05/15.
//  Copyright (c) 2015 riazy. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "LyricSession.h"

@interface LyricSessionTests : XCTestCase

@end

@implementation LyricSessionTests


-(void)testLyricsFetching
{
    //Given
    LyricSession *session = [LyricSession sharedSession];
    XCTestExpectation *expectation = [self expectationWithDescription:@"Timeout"];

    NSString *lyric = @"you made a fool out of me";
    
    //When
    __block id actualItem = nil;
    [session searchLyric:lyric completion:^(NSArray *results, NSError *error) {
        actualItem = results;
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:20 handler:NULL];
    
    //Then
    XCTAssertNotNil(actualItem);
}

@end
