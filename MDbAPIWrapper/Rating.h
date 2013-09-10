//
//  Rating.h
//  MDbAPIWrapper
//
//  Created by Nick on 10/9/13.
//  Copyright (c) 2013 RN Design. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, RatingSource) {
    RatingSourceIMDb,
    RatingSourceTMDb,
    RatingSourceRottenTomatoesCritics,
    RatingSourceRottenTomatoesUser,
    RatingSourceDouban
};

@interface Rating : NSObject

@property enum RatingSource source;
@property NSNumber *average;
@property NSNumber *votes;

- (id) initWithSource:(enum RatingSource)source;

@end
