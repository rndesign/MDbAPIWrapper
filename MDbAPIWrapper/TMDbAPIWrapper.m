//
//  Files: TMDbAPIWrapper.h
//
//  Copyright: (c) 2013 RN Design.
//  License: GNU General Public License, version 2.
//

#import "TMDbAPIWrapper.h"
#import "AFJSONRequestOperation.h"

NSString *IMAGE_BASE_URL = @"http://d3gtl9l2a4fn1j.cloudfront.net/t/p%@";

@implementation TMDbAPIWrapper

+ (instancetype)sharedInstanceWithAPIKey:(NSString *)apikey {
    static TMDbAPIWrapper *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        NSURL *url = [NSURL URLWithString:@"http://api.themoviedb.org/3/"];
        
        _sharedInstance = [[self alloc] init];
        _sharedInstance.httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
        _sharedInstance.parameters = @{@"api_key":apikey};
    });
    
    return _sharedInstance;
}

- (AFHTTPRequestOperation *)getAFHTTPOperationForFetchingMovies:(enum MovieListType)type {
    NSString *relativePath = nil;
    switch (type) {
        case MovieListTypeUpcoming:
            relativePath = @"movie/upcoming";
            break;
        case MovieListTypeOpening:
            relativePath = @"movie/now_playing";
            break;
        case MovieListTypePopular:
            relativePath = @"movie/popular";
            break;
        case MovieListTypeTopRated:
            relativePath = @"movie/top_rated";
            break;
        default:
            relativePath = @"movie/now_playing";
            break;
    }
    
    NSMutableURLRequest *request = [self.httpClient requestWithMethod:@"GET" path:relativePath parameters:self.parameters];
    return [[AFJSONRequestOperation alloc] initWithRequest:request];
}

- (void)fetchMovies:(enum MovieListType)type
            success:(void (^)(NSArray *))success
            failure:(void (^)(NSError *))failure {
    AFHTTPRequestOperation *operation = [self getAFHTTPOperationForFetchingMovies:type];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            NSArray *rawData = [responseObject objectForKey:@"results"];
            NSMutableArray *movies = [[NSMutableArray alloc] initWithCapacity:[rawData count]];
            
            for (id record in rawData) {
                [movies addObject:[self compositeMovieObjectFromData:record]];
            }
            
            success(movies);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) failure(error);
    }];
    
    [operation start];
}

- (AFHTTPRequestOperation *)getAFHTTPOperationForFetchingMovieByIMDbID:(NSString *)imdbID {
    NSString *path = [NSString stringWithFormat:@"movie/%@", imdbID];
    NSMutableURLRequest *request = [self.httpClient requestWithMethod:@"GET" path:path parameters:self.parameters];
    return [[AFJSONRequestOperation alloc] initWithRequest:request];
}

- (void)fetchMovieByIMDbID:(NSString *)imdbID
               success:(void (^)(Movie *))success
               failure:(void (^)(NSError *))failure {
    AFHTTPRequestOperation *operation = [self getAFHTTPOperationForFetchingMovieByIMDbID:imdbID];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) success([self compositeMovieObjectFromData:responseObject]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) failure(error);
    }];

    [operation start];
}

- (Movie *)compositeMovieObjectFromData:(id)data {
    Movie *movie = [[Movie alloc] initWithTitle:[data objectForKey:@"Title"]];
    movie.movieID = [data objectForKey:@"id"];
    movie.imdbID = [data objectForKey:@"imdb_id"];
    
    Artwork *poster = [[Artwork alloc] initWithType:ArtworkTypePoster];
    poster.movieID = movie.imdbID;
    NSString *posterPath = [NSString stringWithFormat:@"/w500%@", [data objectForKey:@"poster_path"]];
    poster.remotePath = [NSString stringWithFormat:IMAGE_BASE_URL, posterPath];
    movie.poster = poster;
    
    Artwork *backdrop = [[Artwork alloc] initWithType:ArtworkTypeBackdrop];
    backdrop.movieID = movie.imdbID;
    NSString *backdropPath = [NSString stringWithFormat:@"/w780%@", [data objectForKey:@"backdrop_path"]];
    backdrop.remotePath = [NSString stringWithFormat:IMAGE_BASE_URL, backdropPath];
    movie.backdrop = backdrop;
    
    return movie;
}

@end
