//
//  Files: TMDbAPIWrapper.h
//
//  Copyright: (c) 2013 RN Design.
//  License: GNU General Public License, version 2.
//

#import <Foundation/Foundation.h>
#import "MDbAPIWrapperProtocol.h"

/*
 TMDb API: http://docs.themoviedb.apiary.io/
 */
@interface TMDbAPIWrapper : NSObject <MDbAPIWrapperProtocol>

+ (instancetype)sharedInstanceWithAPIKey:(NSString *)apiKey;

- (void)setBaseURL:(NSString *)baseURL;

- (void)fetchMovieList:(enum MovieListType)type
               success:(void (^)(NSArray *))success
               failure:(void (^)(NSError *))failure;

@end
