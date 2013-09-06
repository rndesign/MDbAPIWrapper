//
//  OMDbAPIWrapper.m
//  MDbAPIWrapper
//
//  Created by Nick on 7/9/13.
//  Copyright (c) 2013 RN Design. All rights reserved.
//

#import "OMDbAPIWrapper.h"
#import "AFJSONRequestOperation.h"

@implementation OMDbAPIWrapper

NSString *BASE_URL = @"http://www.omdbapi.com?";

+ (instancetype)sharedWrapper {
    static OMDbAPIWrapper *_sharedWrapper = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedWrapper = [[self alloc] init];
    });
    
    return _sharedWrapper;
}

- (void)fetchMovieByID:(NSString *)movieID success:(void (^)(Movie *))success failure:(void (^)(NSError *))failure {
    NSString *requestURL = [self compositeRequestURLWithParameters:@{ @"i":movieID }];
    NSURL *url = [NSURL URLWithString:requestURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        Movie *movie = [[Movie alloc] init];
        success(movie);
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        failure(error);
    }];
    
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
    [operation start];
}

- (NSString *)compositeRequestURLWithParameters:(NSDictionary *)parameters {
    NSString *compositedURL = nil;
    
    for (id param in parameters) {
        NSString *formattedValue = [[param value] stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        compositedURL = [BASE_URL stringByAppendingFormat:@"%@=%@&", [param key], formattedValue];
    }
    
    return compositedURL;
}

@end
