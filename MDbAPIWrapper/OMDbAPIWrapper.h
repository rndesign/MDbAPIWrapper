//
//  Files: OMDbAPIWrapper.h
//
//  Copyright: (c) 2013 RN Design.
//  License: GNU General Public License, version 2.
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
