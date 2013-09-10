//
//  Files: Artwork.h
//
//  Copyright: (c) 2013 RN Design.
//  License: GNU General Public License, version 2.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, ArtworkType) {
    ArtworkTypeImage,
    ArtworkTypeVideo
};

@interface Artwork : NSObject

@property (nonatomic) enum ArtworkType type;
@property (nonatomic, strong) NSString *movieID;
@property (nonatomic, strong) NSString *localPath;
@property (nonatomic, strong) NSString *remotePath;

/*
 Since the IMDb ID can be used by MDb API, so it's better to stick with it.
 */
- (id)initWithIMDbID:(NSString *)imdbID type:(enum ArtworkType)type;

@end
