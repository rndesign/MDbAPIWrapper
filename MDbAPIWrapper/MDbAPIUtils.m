//
//  Files: MDbAPIUtils.m
//
//  Copyright: (c) 2013 RN Design.
//  License: GNU General Public License, version 2.
//

#import "MDbAPIUtils.h"
#import "AFImageRequestOperation.h"

@implementation MDbAPIUtils

+ (NSString *)compositeRequestURL:(NSString *)baseURL parameters:(NSDictionary *)parameters {
    NSString *formattedParams = [[NSString alloc] init];
    
    for (id paramName in parameters) {
        NSString *paramValue = [parameters objectForKey:paramName];
        NSString *encodedParamValue = [paramValue stringByReplacingOccurrencesOfString:@" " withString:@"+"];
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

@end
