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

@property (strong, nonatomic) NSString *key;
@property (strong, nonatomic) NSString *baseURL;
@property (strong, nonatomic) NSString *imageBaseURL;

+ (instancetype)sharedInstanceWithKey:(NSString *)key;

- (void)fetchMovieList:(enum MovieListTypeTMDb)type
               success:(void (^)(NSArray *))success
               failure:(void (^)(NSError *))failure;

- (void)fetchMovieByID:(NSString *)movieID
               success:(void (^)(Movie *))success
               failure:(void (^)(NSError *))failure;

@end
