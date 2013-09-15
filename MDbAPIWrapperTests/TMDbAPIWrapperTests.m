//
//  TMDbAPIWrapperTests.m
//  MDbAPIWrapper
//
//  Created by Nick on 11/9/13.
//  Copyright (c) 2013 RN Design. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TMDbAPIWrapper.h"

@interface TMDbAPIWrapperTests : XCTestCase

@end

@implementation TMDbAPIWrapperTests

static NSString *API_KEY = @"f004eff5d496e13b624315e9e86fbb2b";

- (void)setUp {
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
}

- (void)tearDown {
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

- (void)testFetchUpcomingMovieList {
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    TMDbAPIWrapper *wrapper = [TMDbAPIWrapper sharedInstanceWithAPIKey:API_KEY];
    [wrapper fetchMovieList:MovieListTypeTMDbUpcoming success:^(NSArray *movies) {
        XCTAssert(movies);
        XCTAssert([movies count] == 20);
        dispatch_semaphore_signal(semaphore);
    } failure:^(NSError *error) {
        XCTFail(@"Failed because of %@", [error userInfo]);
        dispatch_semaphore_signal(semaphore);
    }];
    
    while (dispatch_semaphore_wait(semaphore, DISPATCH_TIME_NOW))
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                 beforeDate:[NSDate dateWithTimeIntervalSinceNow:10]];
}

- (void)testFetchNowPlayingMovieList {
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    TMDbAPIWrapper *wrapper = [TMDbAPIWrapper sharedInstanceWithAPIKey:API_KEY];
    [wrapper fetchMovieList:MovieListTypeTMDbNowPlaying success:^(NSArray *movies) {
        XCTAssert(movies);
        XCTAssert([movies count] == 20);
        dispatch_semaphore_signal(semaphore);
    } failure:^(NSError *error) {
        XCTFail(@"Failed because of %@", [error userInfo]);
        dispatch_semaphore_signal(semaphore);
    }];
    
    while (dispatch_semaphore_wait(semaphore, DISPATCH_TIME_NOW))
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                 beforeDate:[NSDate dateWithTimeIntervalSinceNow:10]];
}

- (void)testFetchPopularMovieList {
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    TMDbAPIWrapper *wrapper = [TMDbAPIWrapper sharedInstanceWithAPIKey:API_KEY];
    [wrapper fetchMovieList:MovieListTypeTMDbPopular success:^(NSArray *movies) {
        XCTAssert(movies);
        XCTAssert([movies count] == 20);
        dispatch_semaphore_signal(semaphore);
    } failure:^(NSError *error) {
        XCTFail(@"Failed because of %@", [error userInfo]);
        dispatch_semaphore_signal(semaphore);
    }];
    
    while (dispatch_semaphore_wait(semaphore, DISPATCH_TIME_NOW))
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                 beforeDate:[NSDate dateWithTimeIntervalSinceNow:10]];
}

- (void)testFetchTopRatedMovieList {
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    TMDbAPIWrapper *wrapper = [TMDbAPIWrapper sharedInstanceWithAPIKey:API_KEY];
    [wrapper fetchMovieList:MovieListTypeTMDbTopRated success:^(NSArray *movies) {
        XCTAssert(movies);
        XCTAssert([movies count] == 20);
        dispatch_semaphore_signal(semaphore);
    } failure:^(NSError *error) {
        XCTFail(@"Failed because of %@", [error userInfo]);
        dispatch_semaphore_signal(semaphore);
    }];
    
    while (dispatch_semaphore_wait(semaphore, DISPATCH_TIME_NOW))
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                 beforeDate:[NSDate dateWithTimeIntervalSinceNow:10]];
}


@end
