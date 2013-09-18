//
//  Files: OMDbAPIWrapper.m
//
//  Copyright: (c) 2013 RN Design.
//  License: GNU General Public License, version 2.
//

#import "OMDbAPIWrapper.h"
#import "MDbAPIUtils.h"
#import "AFJSONRequestOperation.h"

@implementation OMDbAPIWrapper

+ (instancetype)sharedInstance {
    static OMDbAPIWrapper *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{        
        NSURL *url = [NSURL URLWithString:@"http://www.omdbapi.com/"];
        
        _sharedInstance = [[self alloc] init];
        _sharedInstance.httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    });
    
    return _sharedInstance;
}

- (AFHTTPRequestOperation *)getAFHTTPOperationForFetchingMovieByIMDbID:(NSString *)imdbID {
    NSMutableURLRequest *request = [self.httpClient requestWithMethod:@"GET" path:@"" parameters:self.parameters];
    return [[AFJSONRequestOperation alloc] initWithRequest:request];
}

- (void)fetchMovieByIMDbID:(NSString *)imdbID
                   success:(void (^)(Movie *))success
                   failure:(void (^)(NSError *))failure {
    self.parameters = @{@"i":imdbID};
    AFHTTPRequestOperation *operation = [self getAFHTTPOperationForFetchingMovieByIMDbID:imdbID];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            Movie *movie = [[Movie alloc] initWithTitle:[responseObject objectForKey:@"Title"]];
            movie.movieID = [responseObject objectForKey:@"imdbID"];
            movie.imdbID = movie.movieID;
            
            Artwork *poster = [[Artwork alloc] initWithType:ArtworkTypePoster];
            poster.movieID = movie.movieID;
            NSString *posterURL = [responseObject objectForKey:@"Poster"];
            poster.remotePath = [posterURL stringByReplacingOccurrencesOfString:@"SX300" withString:@"SX600"];
            movie.poster = poster;
            
            Rating *rating = [[Rating alloc] initWithSource:RatingSourceIMDb];
            rating.average = [responseObject objectForKey:@"imdbRating"];
            rating.votes = [responseObject objectForKey:@"imdbVotes"];
            [movie.ratings setObject:rating forKey:[NSNumber numberWithInt:RatingSourceIMDb]];
            
            success(movie);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) failure(error);
    }];
    
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
    [operation start];
}

@end
