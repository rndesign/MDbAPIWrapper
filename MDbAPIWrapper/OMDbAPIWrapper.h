//
//  Files: OMDbAPIWrapper.h
//
//  Copyright: (c) 2013 RN Design.
//  License: GNU General Public License, version 2.
//

#import <Foundation/Foundation.h>
#import "Movie.h"

/*
 OMDb API: http://www.omdbapi.com
 */
@interface OMDbAPIWrapper : NSObject

@property (nonatomic) BOOL fullPlot;
@property (nonatomic) BOOL tomatoesInclude;

+ (instancetype)sharedInstance;

+ (void)setBaseURL:(NSString *)baseURL;

- (void)fetchMovieByID:(NSString *)movieID success:(void (^)(Movie *))success failure:(void (^)(NSError *))failure;

@end
