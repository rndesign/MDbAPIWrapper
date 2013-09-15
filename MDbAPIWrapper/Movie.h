//
//  Files: Movie.h
//
//  Copyright: (c) 2013 RN Design.
//  License: GNU General Public License, version 2.
//

#import <Foundation/Foundation.h>
#import "Artwork.h"
#import "Rating.h"

@interface Movie : NSObject

@property (nonatomic, strong) NSString *movieID;    // MDb own ID
@property (nonatomic, strong) NSString *imdbID;     // IMDb ID
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) Artwork *poster;
@property (nonatomic, strong) Artwork *backdrop;
@property (nonatomic, strong) NSMutableDictionary *ratings;

- (id)initWithTitle:(NSString *)title;

@end
