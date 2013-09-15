//
//  Files: RottenTomatoesAPIWrapper.m
//
//  Copyright: (c) 2013 RN Design.
//  License: GNU General Public License, version 2.
//

#import "RottenTomatoesAPIWrapper.h"
#import "AFJSONRequestOperation.h"

@implementation RottenTomatoesAPIWrapper

static NSInteger LIMIT = 10;
static NSString *BASE_URL = @"http://api.rottentomatoes.com/api/public/v1.0/%@?api_key=%@&page_limit=%d";
static NSString *API_KEY;

+ (instancetype)sharedInstanceWithAPIKey:(NSString *)apiKey {
    static RottenTomatoesAPIWrapper *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[self alloc] init];
        API_KEY = apiKey;
    });
    
    return _sharedInstance;
}

- (void)setBaseURL:(NSString *)baseURL {
    BASE_URL = baseURL;
}

- (void)setLimitForMovieList:(NSInteger)limit {
    LIMIT = limit;
}

- (void)fetchMovieList:(enum MovieListTypeRT)type
               success:(void (^)(NSArray *))success
               failure:(void (^)(NSError *))failure {
    NSString *functionName = nil;
    switch (type) {
        case MovieListTypeRTBoxOffice:
            functionName = @"lists/movies/box_office.json";
            break;
        case MovieListTypeRTInTheaters:
            functionName = @"lists/movies/in_theaters.json";
            break;
        case MovieListTypeRTOpening:
            functionName = @"lists/movies/opening.json";
            break;
        case MovieListTypeRTUpcoming:
            functionName = @"lists/movies/upcoming.json";
            break;
        default:
            functionName = @"lists/movies/box_office.json";
            break;
    }
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:BASE_URL, functionName, API_KEY, LIMIT]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
    success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        if (success) {
            NSArray *rawData = [JSON objectForKey:@"movies"];
            NSMutableArray *movies = [[NSMutableArray alloc] initWithCapacity:[rawData count]];
            
            for (id record in rawData) {
                Movie *movie = [[Movie alloc] initWithTitle:[record objectForKey:@"title"]];
                movie.movieID = [record objectForKey:@"id"];
                movie.imdbID = [[record objectForKey:@"alternate_ids"] objectForKey:@"imdb"];
                
                [movies addObject:movie];
            }
            
            success(movies);
        }
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        if (failure) failure(error);
    }];
    
    [operation start];
}

@end
