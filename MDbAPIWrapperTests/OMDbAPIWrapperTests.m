//
//  Files: OMDbAPIWrapperTests.h
//
//  Copyright: (c) 2013 RN Design.
//  License: GNU General Public License, version 2.
//

#import <XCTest/XCTest.h>
#import "OMDbAPIWrapper.h"
#import "Movie.h"

@interface OMDbAPIWrapperTests : XCTestCase

@end

@implementation OMDbAPIWrapperTests

OMDbAPIWrapper *wrapper;

- (void)setUp {
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
    wrapper = [OMDbAPIWrapper sharedInstance];
}

- (void)tearDown {
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

- (void)testFetchMovie {
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    [wrapper fetchMovieByID:@"tt1285016" success:^(Movie *movie) {
        XCTAssertTrue(movie.movieID, @"tt1285015");
        XCTAssertTrue(movie.title = @"The Social Network");
    
        dispatch_semaphore_signal(semaphore);
    } failure:^(NSError *error) {
        XCTFail(@"Failed because of %@", [error userInfo]);
        dispatch_semaphore_signal(semaphore);
    }];
    
    while (dispatch_semaphore_wait(semaphore, DISPATCH_TIME_NOW))
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                 beforeDate:[NSDate dateWithTimeIntervalSinceNow:10]];
}

- (void)testFetchMovieWithInvalidID {
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    [wrapper fetchMovieByID:@"tt1285016" success:^(Movie *movie) {
        XCTAssertTrue(movie.title == nil);
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
