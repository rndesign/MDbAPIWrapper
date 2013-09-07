//
//  OMDbAPIWrapper.h
//
//  Created by Nick on 7/9/13.
//  Copyright (c) 2013 RN Design. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MDbAPIWrapperProtocol.h"

/*
 OMDb API: http://www.omdbapi.com
 */
@interface OMDbAPIWrapper : NSObject <MDbAPIWrapperProtocol>

@property (nonatomic) BOOL fullPlot;
@property (nonatomic) BOOL tomatoesInclude;

+ (instancetype)sharedInstance;

@end
