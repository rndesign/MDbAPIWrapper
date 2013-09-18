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

+ (void)setYouTuBeBaseURL:(NSString *)baseURL;

+ (NSString *)stripStringIfHasColon:(NSString *)string;

+ (void)fetchImageArtwork:(Artwork *)artwork
     imageProcessingBlock:(UIImage *(^)(UIImage *))imageProcessingBlock
               storeImage:(BOOL)storeImage
                  success:(void(^)(UIImage *))success
                  failure:(void(^)(NSError *error))failure;

+ (void)fetchImageArtwork:(Artwork *)artwork
               storeImage:(BOOL)storeImage
                  success:(void(^)(UIImage *))success
                  failure:(void(^)(NSError *error))failure;

+ (void)fetchImageArtwork:(Artwork *)artwork storeImage:(BOOL)storeImage;

+ (void)fetchTrailerURLFromYouTube:(NSString *)title
                           success:(void(^)(NSString *videoURL))success
                           failure:(void(^)(NSError *error))failure;

@end
