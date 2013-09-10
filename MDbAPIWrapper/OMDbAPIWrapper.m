//
//  Files: OMDbAPIWrapper.m
//
//  Copyright: (c) 2013 RN Design.
//  License: GNU General Public License, version 2.
//

#import "Artwork.h"
#import "MDbAPIUtils.h"
#import "OMDbAPIWrapper.h"
#import "AFJSONRequestOperation.h"

@implementation OMDbAPIWrapper

static NSString *BASE_URL = @"http://www.omdbapi.com?";

+ (instancetype)sharedInstance {
    static OMDbAPIWrapper *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[self alloc] init];
    });
    
    return _sharedInstance;
}

+ (void)setBaseURL:(NSString *)baseURL {
    BASE_URL = baseURL;
}

- (void)fetchMovieByID:(NSString *)movieID success:(void (^)(Movie *))success failure:(void (^)(NSError *))failure {
    NSString *plotParam = self.fullPlot ? @"full" : @"short";
    NSString *tomatoesInclude = self.tomatoesInclude ? @"true" : @"false";
    NSDictionary *parameters = @{ @"i":movieID, @"plot":plotParam, @"tomatoes":tomatoesInclude };
    
    NSString *requestURL = [MDbAPIUtils compositeRequestURL:BASE_URL parameters:parameters];
    NSURL *url = [NSURL URLWithString:requestURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        if (success) {
            Movie *movie = [[Movie alloc] init];
            
            movie.movieID = [JSON objectForKey:@"imdbID"];
            movie.title = [JSON objectForKey:@"title"];
            movie.imdbID = movie.movieID;
            
            Artwork *poster = [[Artwork alloc] init];
            poster.remotePath = [JSON objectForKey:@"Poster"];
            movie.poster = poster;
            
            success(movie);
        }
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        if (failure) failure(error);
    }];
    
    // have to add "text/html" to acceptable content types
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
    [operation start];
}

@end
