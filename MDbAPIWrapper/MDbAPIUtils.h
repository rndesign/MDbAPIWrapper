//
//  Files: MDbAPIUtils.h
//
//  Copyright: (c) 2013 RN Design.
//  License: GNU General Public License, version 2.
//

#import <Foundation/Foundation.h>

@interface MDbAPIUtils : NSObject

+ (NSString *)compositeRequestURL:(NSString *)baseURL parameters:(NSDictionary *)parameters;

@end
