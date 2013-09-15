//
//  Files: TMDbAPIWrapper.h
//
//  Copyright: (c) 2013 RN Design.
//  License: GNU General Public License, version 2.
//

#import "TMDbAPIWrapper.h"
#import "AFJSONRequestOperation.h"

@implementation TMDbAPIWrapper

+ (instancetype)sharedInstanceWithKey:(NSString *)key {
    static TMDbAPIWrapper *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[self alloc] init];
        _sharedInstance.key = key;
        _sharedInstance.baseURL = @"http://api.themoviedb.org/3/%@?api_key=%@";
        _sharedInstance.imageBaseURL = @"http://d3gtl9l2a4fn1j.cloudfront.net/t/p%@";
    });
    
    return _sharedInstance;
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
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:self.baseURL, functionName, self.key]];
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
                NSString *posterPath = [NSString stringWithFormat:@"/w500/%@", [record objectForKey:@"poster_path"]];
                poster.remotePath = [NSString stringWithFormat:self.imageBaseURL, posterPath];
                movie.poster = poster;
                
                Artwork *backdrop = [[Artwork alloc] initWithType:ArtworkTypeBackdrop];
                backdrop.movieID = movie.movieID;
                NSString *backdropPath = [NSString stringWithFormat:@"/w780/%@", [record objectForKey:@"poster_path"]];
                backdrop.remotePath = [NSString stringWithFormat:self.imageBaseURL, backdropPath];
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

- (void)fetchMovieByID:(NSString *)movieID
               success:(void (^)(Movie *))success
               failure:(void (^)(NSError *))failure {
    NSString *query = [NSString stringWithFormat:@"movie/%@", movieID];
    NSString *urlString = [NSString stringWithFormat:self.baseURL, query, self.key];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
      success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        if (success) {
            Movie *movie = [[Movie alloc] initWithTitle:[JSON objectForKey:@"Title"]];
            movie.movieID = [JSON objectForKey:@"id"];
            movie.imdbID = [JSON objectForKey:@"imdb_id"];
            
            Artwork *poster = [[Artwork alloc] initWithType:ArtworkTypePoster];
            poster.movieID = movie.movieID;
            NSString *posterPath = [NSString stringWithFormat:@"/w500%@", [JSON objectForKey:@"poster_path"]];
            poster.remotePath = [NSString stringWithFormat:self.imageBaseURL, posterPath];
            movie.poster = poster;
            
            Artwork *backdrop = [[Artwork alloc] initWithType:ArtworkTypeBackdrop];
            backdrop.movieID = movie.movieID;
            NSString *backdropPath = [NSString stringWithFormat:@"/w780%@", [JSON objectForKey:@"backdrop_path"]];
            backdrop.remotePath = [NSString stringWithFormat:self.imageBaseURL, backdropPath];
            movie.backdrop = backdrop;
            
            success(movie);
        }
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        if (failure) failure(error);
    }];
    
    [operation start];
}

@end
