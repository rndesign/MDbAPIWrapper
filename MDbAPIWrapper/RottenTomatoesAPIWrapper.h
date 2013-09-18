//
//  Files: RottenTomatoesAPIWrapper.h
//
//  Copyright: (c) 2013 RN Design.
//  License: GNU General Public License, version 2.
//

#import <Foundation/Foundation.h>
#import "APIWrapper.h"

/*
 Rotten Tomatoes API: http://developer.rottentomatoes.com/docs
 */
@interface RottenTomatoesAPIWrapper : APIWrapper

@property (strong, nonatomic) AFHTTPClient *httpClient;
@property (strong, nonatomic) NSDictionary *parameters;

+ (instancetype)sharedInstanceWithAPIKey:(NSString *)apiKey;

- (AFHTTPRequestOperation *)getAFHTTPOperationForFetchingMovies:(enum MovieListType)type;

- (void)fetchMovies:(enum MovieListType)type
               success:(void (^)(NSArray *))success
               failure:(void (^)(NSError *))failure;

@end
