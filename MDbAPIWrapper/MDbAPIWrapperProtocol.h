//
//  Files: MDbAPIWrapperProtocol.h
//
//  Copyright: (c) 2013 RN Design.
//  License: GNU General Public License, version 2.
//

#import <Foundation/Foundation.h>

@class Movie

typedef NS_ENUM(NSInteger, MovieListType) {
    MovieListTypeBoxOffice,
    MovieListTypeInTheaters,
    MovieListTypeOpening,
    MovieListTypeUpcoming,
    MovieListTypePopular,
    MovieListTypeTop
} MovieListType;

@protocol MDbAPIWrapperProtocol <NSObject>

@required
- (void)fetchMovie:(NSString *movieID)
               success:(void (^)(Movie *movie))success
               failure:(void (^)(NSError *error))failure;

@optional
- (void)fetchMovieList:(MovieListType *)type
                 limit:(NSInteger)limit
               success:(void (^)(NSArray *movieList))success
               failure:(void (^)(NSError *error))failure;

@end
