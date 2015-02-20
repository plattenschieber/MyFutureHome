//
//  ALSDocumentElement.h
//  MyFutureHome
//
//  Created by Jeronim Morina on 20.02.15.
//  Copyright (c) 2015 SI2. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ALSDocumentElement : NSObject

@property NSString *text;
@property NSString *elementClass;
@property NSString *elementType;
@property int level;
@property NSArray *contents;


@end
