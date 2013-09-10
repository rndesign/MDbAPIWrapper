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
/*
 For unit testing only!
 + (instancetype)sharedInstanceWithAPIKey:(NSString *)apiKey callback:(void(^)(void))callback;
 */

+ (void)setBaseURL:(NSString *)baseURL;
- (NSDictionary *)getImageConfiguration;
- (NSDictionary *)getKeysConfiguration;

@end
