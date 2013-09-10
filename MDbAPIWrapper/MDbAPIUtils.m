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

NSString *YOUTUBE_BASE_URL = @"http://gdata.youtube.com/feeds/api/videos?q=%@-trailer&start-index=1&max-results=1&v=2&alt=json&hd";

+ (NSString *)encodeURLParameterValue:(NSString *)value {
    return [value stringByReplacingOccurrencesOfString:@" " withString:@"+"];
}

+ (NSString *)compositeRequestURL:(NSString *)baseURL parameters:(NSDictionary *)parameters {
    NSString *formattedParams = [[NSString alloc] init];
    
    for (id paramName in parameters) {
        NSString *paramValue = [parameters objectForKey:paramName];
        NSString *encodedParamValue = [self encodeURLParameterValue:paramValue];
        formattedParams = [formattedParams stringByAppendingFormat:@"%@=%@&", paramName, encodedParamValue];
    }
    
    return [baseURL stringByAppendingString:formattedParams];
}

+ (void)fetchImageArtwork:(Artwork *)artwork
     imageProcessingBlock:(UIImage *(^)(UIImage *))imageProcessingBlock
             success:(void (^)(UIImage *))success
             failure:(void (^)(NSError *))failure {
    if (artwork.type != ArtworkTypeImage) return;

    if ([[NSFileManager defaultManager] fileExistsAtPath:artwork.localPath]) {
        NSData *imageData = [NSData dataWithContentsOfFile:artwork.localPath];
        success(imageProcessingBlock([UIImage imageWithData:imageData]));
    } else {
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:artwork.remotePath]];
        AFImageRequestOperation *operation = [AFImageRequestOperation imageRequestOperationWithRequest:request imageProcessingBlock:^UIImage *(UIImage *image) {
            // always store the original artkwork with PNG format
            NSData *imageData = UIImagePNGRepresentation(image);
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
            NSString *documentsPath = [paths objectAtIndex:0];
            NSString *filename = [NSString stringWithFormat:@"/%@.png", artwork.movieID];
            NSString *filePath = [documentsPath stringByAppendingString:filename];
            dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [imageData writeToFile:filePath atomically:YES];
                artwork.localPath = filePath;
            });
            
            return imageProcessingBlock ? imageProcessingBlock(image) : image;
        } success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            if (success) success(image);
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
            NSLog(@"Error happened for the request on %@: %@", [[request URL] absoluteString],[error userInfo]);
            if (failure) failure(error);
        }];
        
        [operation start];
    }
}

+ (void)setYouTuBeBaseURL:(NSString *)baseURL {
    YOUTUBE_BASE_URL = baseURL;
}

+ (void)fetchTrailerURLFromYouTube:(NSString *)title
                success:(void (^)(NSString *))success
                failure:(void (^)(NSError *))failure {
    // strip title
    NSRange range = [title rangeOfString:@":"];
    if (range.location != NSNotFound) title = [title substringToIndex:range.location];
    // encode title
    title = [self encodeURLParameterValue:title];
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
