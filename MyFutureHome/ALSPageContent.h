//
//  ALSPageContent.h
//  MyFutureHome
//
//  Created by Jeronim Morina on 19.02.15.
//  Copyright (c) 2015 SI2. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ALSPageContentPosition.h"

@interface ALSPageContent : NSObject

@property NSString *contentType;
@property NSArray *documentElements;
@property ALSPageContentPosition *position;

@end
