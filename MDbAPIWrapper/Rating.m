//
//  Rating.m
//  MDbAPIWrapper
//
//  Created by Nick on 10/9/13.
//  Copyright (c) 2013 RN Design. All rights reserved.
//

#import "Rating.h"

@implementation Rating

- (id) initWithSource:(enum RatingSource)source {
    if (self = [super init]) {
        _source = source;
    }
    return self;
}

@end
