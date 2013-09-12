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
        _title = title;
        _ratings = [[NSMutableDictionary alloc] init];
    }
    return self;
}

@end
