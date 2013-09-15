//
//  Files: TMDbAPIWrapper.h
//
//  Copyright: (c) 2013 RN Design.
//  License: GNU General Public License, version 2.
//

#import <Foundation/Foundation.h>
#import "Movie.h"

typedef NS_ENUM(NSInteger, MovieListTypeTMDb) {
    MovieListTypeTMDbUpcoming,
    MovieListTypeTMDbNowPlaying,
    MovieListTypeTMDbPopular,
    MovieListTypeTMDbTopRated
};

/*
 TMDb API: http://docs.themoviedb.apiary.io/
 */
@interface TMDbAPIWrapper : NSObject

+ (instancetype)sharedInstanceWithAPIKey:(NSString *)apiKey;

- (void)setBaseURL:(NSString *)baseURL;

- (void)fetchMovieList:(enum MovieListTypeTMDb)type
               success:(void (^)(NSArray *))success
               failure:(void (^)(NSError *))failure;

@end
