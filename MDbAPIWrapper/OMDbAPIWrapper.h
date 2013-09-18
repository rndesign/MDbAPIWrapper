//
//  Files: OMDbAPIWrapper.h
//
//  Copyright: (c) 2013 RN Design.
//  License: GNU General Public License, version 2.
//

#import <Foundation/Foundation.h>
#import "APIWrapper.h"

/*
 OMDb API: http://www.omdbapi.com
 */
@interface OMDbAPIWrapper : APIWrapper

@property (strong, nonatomic) AFHTTPClient *httpClient;
@property (strong, nonatomic) NSDictionary *parameters;

+ (instancetype)sharedInstance;

- (AFHTTPRequestOperation *)getAFHTTPOperationForFetchingMovieByIMDbID:(NSString *)imdbID;

- (void)fetchMovieByIMDbID:(NSString *)imdbID
                   success:(void (^)(Movie *))success
                   failure:(void (^)(NSError *))failure;

@end
