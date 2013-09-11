//
//  Files: MDbAPIWrapperProtocol.h
//
//  Copyright: (c) 2013 RN Design.
//  License: GNU General Public License, version 2.
//

#import <Foundation/Foundation.h>
#import "Movie.h"

@protocol MDbAPIWrapperProtocol <NSObject>

@optional
- (void)fetchMovieList:(enum MovieListType)type
                 limit:(NSInteger)limit
               success:(void (^)(NSArray *movieList))success
               failure:(void (^)(NSError *error))failure;

- (void)fetchMovieByID:(NSString *)movieID
               success:(void (^)(Movie *movie))success
               failure:(void (^)(NSError *error))failure;

@end
