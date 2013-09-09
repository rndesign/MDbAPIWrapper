//
//  Files: Artwork.m
//
//  Copyright: (c) 2013 RN Design.
//  License: GNU General Public License, version 2.
//

#import "Artwork.h"

@implementation Artwork

- (id)initWithIMDbID:(NSString *)imdbID type:(enum ArtworkType)type {
    if (self = [super init]) {
        self.movieID = imdbID;
        self.type = type;
    }
    return self;
}

@end
