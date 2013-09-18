//
//  Files: RottenTomatoesAPIWrapper.m
//
//  Copyright: (c) 2013 RN Design.
//  License: GNU General Public License, version 2.
//

#import "RottenTomatoesAPIWrapper.h"
#import "AFJSONRequestOperation.h"

@implementation RottenTomatoesAPIWrapper

+ (instancetype)sharedInstanceWithAPIKey:(NSString *)key {
    static RottenTomatoesAPIWrapper *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        NSURL *baseURL = [NSURL URLWithString:@"http://api.rottentomatoes.com/api/public/v1.0/"];
        
        _sharedInstance = [[self alloc] init];
        _sharedInstance.httpClient = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
        _sharedInstance.parameters = @{@"apikey":key};
    });
    
    return _sharedInstance;
}

- (AFHTTPRequestOperation *)getAFHTTPOperationForFetchingMovies:(enum MovieListType)type {
    NSString *relativePath = nil;
    switch (type) {
        case MovieListTypeBoxOffice:
            relativePath = @"lists/movies/box_office.json";
            break;
        case MovieListTypeInTheaters:
            relativePath = @"lists/movies/in_theaters.json";
            break;
        case MovieListTypeOpening:
            relativePath = @"lists/movies/opening.json";
            break;
        case MovieListTypeUpcoming:
            relativePath = @"lists/movies/upcoming.json";
            break;
        default:
            relativePath = @"lists/movies/in_theaters.json";
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
            NSArray *rawData = [responseObject objectForKey:@"movies"];
            NSMutableArray *movies = [[NSMutableArray alloc] initWithCapacity:[rawData count]];
            
            for (id record in rawData) {
                Movie *movie = [[Movie alloc] initWithTitle:[record objectForKey:@"title"]];
                movie.movieID = [record objectForKey:@"id"];
                movie.imdbID = [NSString stringWithFormat:@"tt%@", [[record objectForKey:@"alternate_ids"] objectForKey:@"imdb"]];
                movie.title = [record objectForKey:@"title"];
                
                [movies addObject:movie];
            }
            
            success(movies);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) failure(error);
    }];
    
    [operation start];
}

@end
