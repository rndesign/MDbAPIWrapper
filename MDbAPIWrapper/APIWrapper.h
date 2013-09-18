//
//  Files: APIWrapper.h
//
//  Copyright: (c) 2013 RN Design.
//  License: GNU General Public License, version 2.
//

#import <Foundation/Foundation.h>
#import "AFHTTPClient.h"
#import "Movie.h"

@interface APIWrapper : NSObject

- (AFHTTPRequestOperation *)getAFHTTPOperationForFetchingMovies:(enum MovieListType)type;

- (void)fetchMovies:(enum MovieListType)type
            success:(void (^)(NSArray *))success
            failure:(void (^)(NSError *))failure;

- (AFHTTPRequestOperation *)getAFHTTPOperationForFetchingMovie:(NSString *)movieID;

- (void)fetchMovie:(NSString *)movieID
            success:(void (^)(NSArray *))success
            failure:(void (^)(NSError *))failure;

- (AFHTTPRequestOperation *)getAFHTTPOperationForFetchingMovieByIMDbID:(NSString *)imdbID;

- (void)fetchMovieByIMDbID:(NSString *)imdbID
           success:(void (^)(NSArray *))success
           failure:(void (^)(NSError *))failure;

@end
