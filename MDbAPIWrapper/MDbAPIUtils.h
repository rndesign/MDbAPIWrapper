//
//  Files: MDbAPIUtils.h
//
//  Copyright: (c) 2013 RN Design.
//  License: GNU General Public License, version 2.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Artwork.h"

@interface MDbAPIUtils : NSObject

+ (NSString *)compositeRequestURL:(NSString *)baseURL
                       parameters:(NSDictionary *)parameters;

+ (void)fetchImageArtwork:(Artwork *)artwork
     imageProcessingBlock:(UIImage *(^)(UIImage *))imageProcessingBlock
             success:(void(^)(UIImage *))success
             failure:(void(^)(NSError *error))failure;

+ (void)fetchTrailerURLFromYouTube:(NSString *)title
                success:(void(^)(NSString *videoURL))success
                failure:(void(^)(NSError *error))failure;

@end
