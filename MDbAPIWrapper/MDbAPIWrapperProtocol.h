//
//  Files: MDbAPIWrapperProtocol.h
//
//  Copyright: (c) 2013 RN Design.
//  License: GNU General Public License, version 2.
//

#import <Foundation/Foundation.h>
#import "Movie.h"

typedef NS_ENUM(NSInteger, MovieListType) {
    MovieListTypeBoxOffice,
    MovieListTypeInTheaters,
    MovieListTypeOpening,
    MovieListTypeUpcoming,
    MovieListTypePopular,
    MovieListTypeTop
};

@protocol MDbAPIWrapperProtocol <NSObject>

@optional
- (void)fetchMovieList:(MovieListType *)type
                 limit:(NSInteger)limit
               success:(void (^)(NSArray *movieList))success
               failure:(void (^)(NSError *error))failure;

- (void)fetchMovieByID:(NSString *)movieID
               success:(void (^)(Movie *movie))success
               failure:(void (^)(NSError *error))failure;

@end
