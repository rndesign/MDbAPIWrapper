//
//  MDbAPIUtilsTests.m
//  MDbAPIWrapper
//
//  Created by Nick on 9/9/13.
//  Copyright (c) 2013 RN Design. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MDbAPIUtils.h"
#import "Artwork.h"

@interface MDbAPIUtilsTests : XCTestCase

@end

@implementation MDbAPIUtilsTests

- (void)setUp {
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
}

- (void)tearDown {
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

- (void)testFetchImageArkworkFromRemoteServer{
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    // No local copy can be stored since this library not combined with any app so far
    Artwork *artwork = [[Artwork alloc] initWithIMDbID:@"tt1285016" type:ArtworkTypeImage];
    artwork.remotePath = @"http://ia.media-imdb.com/images/M/MV5BMTM2ODk0NDAwMF5BMl5BanBnXkFtZTcwNTM1MDc2Mw@@._V1_SX300.jpg";
    
    [MDbAPIUtils fetchImageArtwork:artwork imageProcessingBlock:nil success:^(UIImage *image) {
        dispatch_semaphore_signal(semaphore);
        XCTAssertTrue(image);
    } failure:nil];
}

- (void)testFetchInvalidImageArkwork {
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    Artwork *artwork = [[Artwork alloc] initWithIMDbID:@"tt1285016" type:ArtworkTypeImage];
    artwork.remotePath = @"in_the_middle_of_nowhere.jpg";
    
    [MDbAPIUtils fetchImageArtwork:artwork imageProcessingBlock:nil success:nil failure:^(NSError *error) {
        dispatch_semaphore_signal(semaphore);
        XCTAssertTrue(error);
    }];
    
    while (dispatch_semaphore_wait(semaphore, DISPATCH_TIME_NOW)) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                 beforeDate:[NSDate dateWithTimeIntervalSinceNow:10]];
    }
}

- (void)testFetchTrailerURLFromYouTube {
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    [MDbAPIUtils fetchTrailerURLFromYouTube:@"The Social Network" success:^(NSString *videoURL) {
        dispatch_semaphore_signal(semaphore);
        XCTAssertTrue(videoURL);
    } failure:nil];
    
    while (dispatch_semaphore_wait(semaphore, DISPATCH_TIME_NOW)) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                 beforeDate:[NSDate dateWithTimeIntervalSinceNow:10]];
    }
}

- (void)testFetchInvaildTrailerURLFromYouTube {
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    [MDbAPIUtils fetchTrailerURLFromYouTube:@"" success:^(NSString *videoURL) {
        dispatch_semaphore_signal(semaphore);
        XCTAssertTrue(!videoURL);
    } failure:nil];
    
    while (dispatch_semaphore_wait(semaphore, DISPATCH_TIME_NOW)) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                 beforeDate:[NSDate dateWithTimeIntervalSinceNow:10]];
    }
}

@end
