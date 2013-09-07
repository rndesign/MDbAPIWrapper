//
//  Files: Movie.h
//
//  Copyright: (c) 2013 RN Design.
//  License: GNU General Public License, version 2.
//

#import <Foundation/Foundation.h>
#import "Artwork.h"

@interface Movie : NSObject

@property (nonatomic, strong) NSString *movieID;    // MDb own ID
@property (nonatomic, strong) NSString *imdbID;     // IMDb ID
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) Artwork *poster;

@end
