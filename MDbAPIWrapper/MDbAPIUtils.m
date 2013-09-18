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

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    NSString *fileExtension = [artwork.remotePath pathExtension];
    NSString *filename = [NSString stringWithFormat:@"/%@_%d.%@", artwork.movieID, artwork.type, fileExtension];
    NSString *filePath = [documentsPath stringByAppendingString:filename];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:artwork.remotePath]];
        AFImageRequestOperation *operation = [AFImageRequestOperation imageRequestOperationWithRequest:request imageProcessingBlock:^UIImage *(UIImage *image) {
            if (storeImage) {
                NSData *imageData = nil;
                
                if ([fileExtension rangeOfString:@"jpg" options:NSCaseInsensitiveSearch].location != NSNotFound) {
                    imageData = UIImageJPEGRepresentation(image, 0.3);
                } else if ([fileExtension rangeOfString:@"png" options:NSCaseInsensitiveSearch].location != NSNotFound) {
                    imageData = UIImagePNGRepresentation(image);
                } else {
                    NSLog(@"Not supported file extension.");
                }
                
                if (imageData) {
                    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        [imageData writeToFile:filePath atomically:YES];
                        artwork.localPath = filePath;
                    });
                }
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
        if (success) {
            NSData *imageData = [NSData dataWithContentsOfFile:filePath];
            if (imageProcessingBlock) {
                success(imageProcessingBlock([UIImage imageWithData:imageData scale:2]));
            } else {
                success([UIImage imageWithData:imageData]);
            }
        }
    }
}

+ (void)fetchImageArtwork:(Artwork *)artwork storeImage:(BOOL)storeImage
                  success:(void (^)(UIImage *))success
                  failure:(void (^)(NSError *))failure {
    [self fetchImageArtwork:artwork imageProcessingBlock:nil storeImage:storeImage success:success failure:failure];
}

+ (void)fetchImageArtwork:(Artwork *)artwork storeImage:(BOOL)storeImage {
    [self fetchImageArtwork:artwork imageProcessingBlock:nil storeImage:storeImage success:nil failure:nil];
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
