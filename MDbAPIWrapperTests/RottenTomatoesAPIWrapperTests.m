//
//  RottenTomatoesAPIWrapperTests.m
//  MDbAPIWrapper
//
//  Created by Nick on 15/9/13.
//  Copyright (c) 2013 RN Design. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "RottenTomatoesAPIWrapper.h"

@interface RottenTomatoesAPIWrapperTests : XCTestCase

@end

@implementation RottenTomatoesAPIWrapperTests

RottenTomatoesAPIWrapper *wrapper;

- (void)setUp
{
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
    wrapper = [RottenTomatoesAPIWrapper sharedInstanceWithAPIKey:@"you_api_key"];
    [wrapper setLimitForMovieList:10];
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

- (void)testFetchBoxOfficeMovieList {
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    [wrapper fetchMovieList:MovieListTypeRTBoxOffice success:^(NSArray *movies) {
        XCTAssert(movies);
        XCTAssert([movies count] == 10);
        dispatch_semaphore_signal(semaphore);
    } failure:^(NSError *error) {
        dispatch_semaphore_signal(semaphore);
    }];
    
    while (dispatch_semaphore_wait(semaphore, DISPATCH_TIME_NOW))
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                 beforeDate:[NSDate dateWithTimeIntervalSinceNow:10]];
}

- (void)testFetchInTheatersMovieList {
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    [wrapper fetchMovieList:MovieListTypeRTInTheaters success:^(NSArray *movies) {
        XCTAssert(movies);
        XCTAssert([movies count] == 10);
        dispatch_semaphore_signal(semaphore);
    } failure:^(NSError *error) {
        dispatch_semaphore_signal(semaphore);
    }];
    
    while (dispatch_semaphore_wait(semaphore, DISPATCH_TIME_NOW))
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                 beforeDate:[NSDate dateWithTimeIntervalSinceNow:10]];
}

- (void)testFetchOpeningMovieList {
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    [wrapper fetchMovieList:MovieListTypeRTOpening success:^(NSArray *movies) {
        XCTAssert(movies);
        XCTAssert([movies count] == 10);
        dispatch_semaphore_signal(semaphore);
    } failure:^(NSError *error) {
        dispatch_semaphore_signal(semaphore);
    }];
    
    while (dispatch_semaphore_wait(semaphore, DISPATCH_TIME_NOW))
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                 beforeDate:[NSDate dateWithTimeIntervalSinceNow:10]];
}

- (void)testFetchUpcomingMovieList {
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    [wrapper fetchMovieList:MovieListTypeRTUpcoming success:^(NSArray *movies) {
        XCTAssert(movies);
        XCTAssert([movies count] == 10);
        dispatch_semaphore_signal(semaphore);
    } failure:^(NSError *error) {
        dispatch_semaphore_signal(semaphore);
    }];
    
    while (dispatch_semaphore_wait(semaphore, DISPATCH_TIME_NOW))
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                 beforeDate:[NSDate dateWithTimeIntervalSinceNow:10]];
}

@end
