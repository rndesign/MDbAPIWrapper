//
//  Files: Artwork.h
//
//  Copyright: (c) 2013 RN Design.
//  License: GNU General Public License, version 2.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, ArtworkType) {
    ArtworkTypePoster,
    ArtworkTypeBackdrop,
    ArtworkTypeTrailer
};

@interface Artwork : NSObject

@property (nonatomic) enum ArtworkType type;
@property (nonatomic, strong) NSString *movieID;
@property (nonatomic, strong) NSString *localPath;
@property (nonatomic, strong) NSString *remotePath;

- (id)initWithType:(enum ArtworkType)type;

@end
