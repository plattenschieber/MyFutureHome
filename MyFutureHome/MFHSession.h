//
//  MFHSession.h
//  MyFutureHome
//
//  Created by Jeronim Morina on 18.02.15.
//  Copyright (c) 2015 SI2. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MFHUser.h"

@interface MFHSession : NSObject

+ (void) start;
+ (void) printUser;
+ (MFHUser *) getCurrentUser;

@end
