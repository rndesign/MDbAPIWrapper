//
//  Files: TMDbAPIWrapper.h
//
//  Copyright: (c) 2013 RN Design.
//  License: GNU General Public License, version 2.
//

#import "TMDbAPIWrapper.h"
#import "AFJSONRequestOperation.h"

@implementation TMDbAPIWrapper

static NSString *BASE_URL = @"http://api.themoviedb.org/3/%@?api_key=%@";
static NSString *POSTER_BASE_URL = @"http://d3gtl9l2a4fn1j.cloudfront.net/t/p/w500%@";
static NSString *BACKDROP_BASE_URL = @"http://d3gtl9l2a4fn1j.cloudfront.net/t/p/w780%@";
static NSString *API_KEY;

+ (instancetype)sharedInstanceWithAPIKey:(NSString *)apiKey {
    static TMDbAPIWrapper *_sharedInstance = nil;
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

- (void)fetchMovieList:(enum MovieListTypeTMDb)type
               success:(void (^)(NSArray *))success
               failure:(void (^)(NSError *))failure {
    NSString *functionName = nil;
    switch (type) {
        case MovieListTypeTMDbUpcoming:
            functionName = @"movie/upcoming";
            break;
        case MovieListTypeTMDbNowPlaying:
            functionName = @"movie/now_playing";
            break;
        case MovieListTypeTMDbPopular:
            functionName = @"movie/popular";
            break;
        case MovieListTypeTMDbTopRated:
            functionName = @"movie/top_rated";
            break;
        default:
            functionName = @"movie/popular";
            break;
    }
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:BASE_URL, functionName, API_KEY]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
    success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        if (success) {
            NSArray *rawData = [JSON objectForKey:@"results"];
            NSMutableArray *movies = [[NSMutableArray alloc] initWithCapacity:[rawData count]];
            
            for (id record in rawData) {
                Movie *movie = [[Movie alloc] initWithTitle:[record objectForKey:@"title"]];
                movie.movieID = [record objectForKey:@"id"];
                
                Artwork *poster = [[Artwork alloc] initWithType:ArtworkTypePoster];
                poster.movieID = movie.movieID;
                poster.remotePath = [NSString stringWithFormat:POSTER_BASE_URL, [record objectForKey:@"poster_path"]];
                movie.poster = poster;
                
                Artwork *backdrop = [[Artwork alloc] initWithType:ArtworkTypeBackdrop];
                backdrop.movieID = movie.movieID;
                backdrop.remotePath = [NSString stringWithFormat:BACKDROP_BASE_URL, [record objectForKey:@"backdrop_path"]];
                movie.backdrop = backdrop;
                
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
