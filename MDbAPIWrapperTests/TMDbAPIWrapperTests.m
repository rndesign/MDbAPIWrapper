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

TMDbAPIWrapper *wrapper;

- (void)setUp {
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
    wrapper = [TMDbAPIWrapper sharedInstanceWithKey:@"you_api_key"];
}

- (void)tearDown {
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

- (void)testFetchUpcomingMovieList {
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);

    [wrapper fetchMovieList:MovieListTypeTMDbUpcoming success:^(NSArray *movies) {
        XCTAssert(movies);
        XCTAssert([movies count] == 20);
        dispatch_semaphore_signal(semaphore);
    } failure:^(NSError *error) {
        dispatch_semaphore_signal(semaphore);
    }];
    
    while (dispatch_semaphore_wait(semaphore, DISPATCH_TIME_NOW))
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                 beforeDate:[NSDate dateWithTimeIntervalSinceNow:10]];
}

- (void)testFetchNowPlayingMovieList {
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    [wrapper fetchMovieList:MovieListTypeTMDbNowPlaying success:^(NSArray *movies) {
        XCTAssert(movies);
        XCTAssert([movies count] == 20);
        dispatch_semaphore_signal(semaphore);
    } failure:^(NSError *error) {
        dispatch_semaphore_signal(semaphore);
    }];
    
    while (dispatch_semaphore_wait(semaphore, DISPATCH_TIME_NOW))
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                 beforeDate:[NSDate dateWithTimeIntervalSinceNow:10]];
}

- (void)testFetchPopularMovieList {
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    [wrapper fetchMovieList:MovieListTypeTMDbPopular success:^(NSArray *movies) {
        XCTAssert(movies);
        XCTAssert([movies count] == 20);
        dispatch_semaphore_signal(semaphore);
    } failure:^(NSError *error) {
        dispatch_semaphore_signal(semaphore);
    }];
    
    while (dispatch_semaphore_wait(semaphore, DISPATCH_TIME_NOW))
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                 beforeDate:[NSDate dateWithTimeIntervalSinceNow:10]];
}

- (void)testFetchTopRatedMovieList {
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    [wrapper fetchMovieList:MovieListTypeTMDbTopRated success:^(NSArray *movies) {
        XCTAssert(movies);
        XCTAssert([movies count] == 20);
        dispatch_semaphore_signal(semaphore);
    } failure:^(NSError *error) {
        dispatch_semaphore_signal(semaphore);
    }];
    
    while (dispatch_semaphore_wait(semaphore, DISPATCH_TIME_NOW))
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                 beforeDate:[NSDate dateWithTimeIntervalSinceNow:10]];
}

- (void)testFetchMovie {
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    [wrapper fetchMovieByID:@"tt1285016" success:^(Movie *movie) {
        XCTAssertTrue(movie);
        XCTAssertTrue(movie.movieID, @"tt1285015");
        XCTAssertTrue(movie.title = @"The Social Network");
        XCTAssertTrue(movie.poster);
        XCTAssertTrue(movie.backdrop);
        
        dispatch_semaphore_signal(semaphore);
    } failure:^(NSError *error) {
        dispatch_semaphore_signal(semaphore);
    }];
    
    while (dispatch_semaphore_wait(semaphore, DISPATCH_TIME_NOW))
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                 beforeDate:[NSDate dateWithTimeIntervalSinceNow:10]];
}

- (void)testFetchMovieWithInvalidID {
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    [wrapper fetchMovieByID:@"tt" success:^(Movie *movie) {
        XCTAssertTrue(!movie);
        dispatch_semaphore_signal(semaphore);
    } failure:^(NSError *error) {
        dispatch_semaphore_signal(semaphore);
    }];
    
    while (dispatch_semaphore_wait(semaphore, DISPATCH_TIME_NOW))
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                 beforeDate:[NSDate dateWithTimeIntervalSinceNow:10]];
}

@end
