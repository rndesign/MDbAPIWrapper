//
//  Files: MDbAPIUtils.m
//
//  Copyright: (c) 2013 RN Design.
//  License: GNU General Public License, version 2.
//

#import "MDbAPIUtils.h"
#import "AFImageRequestOperation.h"
#import "AFJSONRequestOperation.h"

@implementation MDbAPIUtils

static NSString *YOUTUBE_BASE_URL = @"http://gdata.youtube.com/feeds/api/videos?q=%@-trailer&start-index=1&max-results=1&v=2&alt=json&hd";

+ (void)setYouTuBeBaseURL:(NSString *)baseURL {
    YOUTUBE_BASE_URL = baseURL;
}

+ (NSString *)stripStringIfHasColon:(NSString *)string {
    NSRange range = [string rangeOfString:@":"];
    if (range.location != NSNotFound) return [string substringToIndex:range.location];
    else return string;
}

+ (NSString *)encodeURLParameterValue:(NSString *)value {
    return [value stringByReplacingOccurrencesOfString:@" " withString:@"+"];
}

+ (NSString *)compositeRequestURL:(NSString *)baseURL parameters:(NSDictionary *)parameters {
    NSString *formattedParams = [[NSString alloc] init];
    
    for (id paramName in parameters) {
        formattedParams = [formattedParams stringByAppendingFormat:@"%@=%@&", paramName,
                           [self encodeURLParameterValue:[self stripStringIfHasColon:[parameters objectForKey:paramName]]]];
    }
    
    return [baseURL stringByAppendingString:formattedParams];
}

+ (void)fetchImageArtwork:(Artwork *)artwork
     imageProcessingBlock:(UIImage *(^)(UIImage *))imageProcessingBlock
               storeImage:(BOOL)storeImage
                  success:(void (^)(UIImage *))success
                  failure:(void (^)(NSError *))failure {
    if (artwork.type == ArtworkTypeTrailer) return;

    if (![[NSFileManager defaultManager] fileExistsAtPath:artwork.localPath]) {
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:artwork.remotePath]];
        AFImageRequestOperation *operation = [AFImageRequestOperation imageRequestOperationWithRequest:request imageProcessingBlock:^UIImage *(UIImage *image) {
            if (storeImage) {
                // always store the original artkwork with PNG format
                NSData *imageData = UIImagePNGRepresentation(image);
                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
                NSString *documentsPath = [paths objectAtIndex:0];
                NSString *filename = [NSString stringWithFormat:@"/%@_%d.png", artwork.movieID, artwork.type];
                NSString *filePath = [documentsPath stringByAppendingString:filename];
                dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    [imageData writeToFile:filePath atomically:YES];
                    artwork.localPath = filePath;
                });
            }
            
            return imageProcessingBlock ? imageProcessingBlock(image) : image;
        } success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            if (success) success(image);
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
            NSLog(@"Error happened for the request on %@: %@", [[request URL] absoluteString],[error userInfo]);
            if (failure) failure(error);
        }];
        
        [operation start];
    } else {
        NSData *imageData = [NSData dataWithContentsOfFile:artwork.localPath];
        success(imageProcessingBlock([UIImage imageWithData:imageData]));
    }
}

+ (void)fetchTrailerURLFromYouTube:(NSString *)title
                success:(void (^)(NSString *))success
                failure:(void (^)(NSError *))failure {
    // encode title
    title = [self encodeURLParameterValue:[self stripStringIfHasColon:title]];
    // composite url accodring to source type
    NSString *url = [NSString stringWithFormat:YOUTUBE_BASE_URL, title];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        if (success) {
            NSString *videoURL = videoURL = [[[[[JSON objectForKey:@"feed"] objectForKey:@"entry"] firstObject] objectForKey:@"content"] objectForKey:@"src"];
            
            success(videoURL);
        }
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"Error happened for the request on %@: %@", [[request URL] absoluteString],[error userInfo]);
        if (failure) failure(error);
    }];
    
    [operation start];
}

@end
