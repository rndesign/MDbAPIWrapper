//
//  Files: MDbAPIUtils.m
//
//  Copyright: (c) 2013 RN Design.
//  License: GNU General Public License, version 2.
//

#import "MDbAPIUtils.h"

@implementation MDbAPIUtils

+ (NSString *)compositeRequestURL:(NSString *)baseURL parameters:(NSDictionary *)parameters {
    NSString *formattedParams = [[NSString alloc] init];
    
    for (id paramName in parameters) {
        NSString *paramValue = [self encodeURLParameterValue:[parameters objectForKey:paramName]];
        formattedParams = [formattedParams stringByAppendingFormat:@"%@=%@&", paramName, paramValue];
    }
    
    return [baseURL stringByAppendingString:formattedParams];
}

+ (NSString *)encodeURLParameterValue:(NSString *)value {
    // + is more human readable than %20
    return [value stringByReplacingOccurrencesOfString:@" " withString:@"+"];
}

@end
