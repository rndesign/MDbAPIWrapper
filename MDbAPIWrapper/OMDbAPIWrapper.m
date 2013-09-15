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
        _sharedInstance = [[self alloc] init];
        _sharedInstance.baseURL = @"http://www.omdbapi.com?";
    });
    
    return _sharedInstance;
}

- (void)fetchMovieByID:(NSString *)movieID success:(void (^)(Movie *))success failure:(void (^)(NSError *))failure {
    NSString *plotParam = self.fullPlot ? @"full" : @"short";
    NSString *tomatoesInclude = self.tomatoesInclude ? @"true" : @"false";
    NSDictionary *parameters = @{ @"i":movieID, @"plot":plotParam, @"tomatoes":tomatoesInclude };
    
    NSString *requestURL = [MDbAPIUtils compositeRequestURL:self.baseURL parameters:parameters];
    NSURL *url = [NSURL URLWithString:requestURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        if (success) {
            if ([JSON objectForKey:@"Error"]) {
                success (nil);
            } else {
                Movie *movie = [[Movie alloc] initWithTitle:[JSON objectForKey:@"Title"]];
                movie.movieID = [JSON objectForKey:@"imdbID"];
                movie.imdbID = movie.movieID;
                
                Artwork *poster = [[Artwork alloc] initWithType:ArtworkTypePoster];
                poster.movieID = movie.movieID;
                poster.remotePath = [JSON objectForKey:@"Poster"];
                movie.poster = poster;
                
                Rating *rating = [[Rating alloc] initWithSource:RatingSourceIMDb];
                rating.average = [JSON objectForKey:@"imdbRating"];
                rating.votes = [JSON objectForKey:@"imdbVotes"];
                [movie.ratings setObject:rating forKey:[NSNumber numberWithInt:RatingSourceIMDb]];
                
                success(movie);
            }
        }
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        if (failure) failure(error);
    }];
    
    // have to add "text/html" to acceptable content types
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
    [operation start];
}

@end
