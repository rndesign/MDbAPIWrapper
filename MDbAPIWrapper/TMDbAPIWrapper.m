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
static NSString *API_KEY;
static NSDictionary *IMAGE_CONFIGURATION;
static NSDictionary *KEYS_CONFIGURATION;

+ (instancetype)sharedInstanceWithAPIKey:(NSString *)apiKey {
    static TMDbAPIWrapper *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[self alloc] init];
        API_KEY = apiKey;
        [self initConfigurations];
    });
    
    return _sharedInstance;
}

+ (void)setBaseURL:(NSString *)baseURL {
    BASE_URL = baseURL;
}

+ (void)initConfigurations {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:BASE_URL, @"configuration", API_KEY]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
      success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
          IMAGE_CONFIGURATION = [JSON objectForKey:@"images"];
          KEYS_CONFIGURATION = [JSON objectForKey:@"change_keys"];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        // TODO - read from local JSON file
        
    }];
    
    [operation start];
}

- (NSDictionary *)getImageConfiguration {
    return IMAGE_CONFIGURATION;
}

- (NSDictionary *)getKeysConfiguration {
    return KEYS_CONFIGURATION;
}

@end
