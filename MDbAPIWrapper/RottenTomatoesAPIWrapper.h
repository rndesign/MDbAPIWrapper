//
//  Files: RottenTomatoesAPIWrapper.h
//
//  Copyright: (c) 2013 RN Design.
//  License: GNU General Public License, version 2.
//

#import <Foundation/Foundation.h>
#import "Movie.h"

typedef NS_ENUM(NSInteger, MovieListTypeRT) {
    MovieListTypeRTBoxOffice,
    MovieListTypeRTInTheaters,
    MovieListTypeRTOpening,
    MovieListTypeRTUpcoming
};

/*
 Rotten Tomatoes API: http://developer.rottentomatoes.com/docs
 */
@interface RottenTomatoesAPIWrapper : NSObject

@property (strong, nonatomic) NSString *key;
@property (strong, nonatomic) NSString *baseURL;
@property (nonatomic) NSInteger limit;

+ (instancetype)sharedInstanceWithKey:(NSString *)Key;

- (void)fetchMovieList:(enum MovieListTypeRT)type
               success:(void (^)(NSArray *))success
               failure:(void (^)(NSError *))failure;

@end
