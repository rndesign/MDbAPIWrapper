//
//  OMDbAPIWrapperTests.m
//  MDbAPIWrapper
//
//  Created by Nick on 7/9/13.
//  Copyright (c) 2013 RN Design. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "OMDbAPIWrapper.h"
#import "Movie.h"

@interface OMDbAPIWrapperTests : XCTestCase

@end

@implementation OMDbAPIWrapperTests

OMDbAPIWrapper *wrapper;

- (void)setUp
{
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
    wrapper = [OMDbAPIWrapper sharedInstance];
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

- (void)testFetchMovie
{
    [wrapper fetchMovieByID:@"tt1285016" success:^(Movie *movie) {
        XCTAssertTrue(movie.movieID, @"tt1285015");
        XCTAssertTrue(movie.title = @"The Social Network");
    } failure:nil];
}

@end
