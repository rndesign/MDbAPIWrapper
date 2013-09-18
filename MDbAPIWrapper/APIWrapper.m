//
//  Files: APIWrapper.m
//
//  Copyright: (c) 2013 RN Design.
//  License: GNU General Public License, version 2.
//

#import "APIWrapper.h"

@implementation APIWrapper

- (AFHTTPRequestOperation *)getAFHTTPOperationForFetchingMovies:(enum MovieListType)type {
    return nil;
}

- (void)fetchMovies:(enum MovieListType)type success:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure {
    
}

- (AFHTTPRequestOperation *)getAFHTTPOperationForFetchingMovie:(NSString *)movieID {
    return nil;
}

- (void)fetchMovie:(NSString *)movieID success:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure {
    
}

- (AFHTTPRequestOperation *)getAFHTTPOperationForFetchingMovieByIMDbID:(NSString *)imdbID {
    return nil;
}


- (void)fetchMovieByIMDbID:(NSString *)imdbID success:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure {
    
}

@end
