//
//  OMDbAPIWrapper.h
//  MDbAPIWrapper
//
//  Created by Nick on 7/9/13.
//  Copyright (c) 2013 RN Design. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MDbAPIWrapperProtocol.h"

@interface OMDbAPIWrapper : NSObject <MDbAPIWrapperProtocol>

@property (nonatomic) BOOL fullPlot;
@property (nonatomic) BOOL tomatoesIncluded;

/**
 Returns the shared OMDb API wrapper object for the system.
 
 @return The systemwide OMDb API wrapper.
 */
+ (instancetype)sharedWrapper;

@end
