//
//  ALSDocumentElementContent.h
//  MyFutureHome
//
//  Created by Jeronim Morina on 20.02.15.
//  Copyright (c) 2015 SI2. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ALSDocumentElementContent : NSObject

@property NSString *elementClass;
@property NSString *elementType;
@property NSURL *url;
@property NSString *target;
@property NSArray *contents;

@end
