//
//  Files: Movie.m
//
//  Copyright: (c) 2013 RN Design.
//  License: GNU General Public License, version 2.
//

#import "Movie.h"

@implementation Movie

- (id)initWithTitle:(NSString *)title {
    if (self = [super init]) {
        self.title = title;
        self.ratings = [[NSMutableDictionary alloc] init];
    }
    return self;
}

@end
