//
//  Files: TMDbAPIWrapper.h
//
//  Copyright: (c) 2013 RN Design.
//  License: GNU General Public License, version 2.
//

#import <Foundation/Foundation.h>
#import "APIWrapper.h"

/*
 TMDb API: http://docs.themoviedb.apiary.io/
 */
@interface TMDbAPIWrapper : APIWrapper

@property (strong, nonatomic) AFHTTPClient *httpClient;
@property (strong, nonatomic) NSDictionary *parameters;

+ (instancetype)sharedInstanceWithAPIKey:(NSString *)apikey;

- (AFHTTPRequestOperation *)getAFHTTPOperationForFetchingMovies:(enum MovieListType)type;

- (void)fetchMovies:(enum MovieListType)type
            success:(void (^)(NSArray *))success
            failure:(void (^)(NSError *))failure;

- (AFHTTPRequestOperation *)getAFHTTPOperationForFetchingMovieByIMDbID:(NSString *)imdbID;

- (void)fetchMovieByIMDbID:(NSString *)imdbID
                   success:(void (^)(Movie *))success
                   failure:(void (^)(NSError *))failure;

@end
