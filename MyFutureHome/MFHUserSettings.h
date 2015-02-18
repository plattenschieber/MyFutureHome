//
//  MFHUserSettings.h
//  MyFutureHome
//
//  Created by Jeronim Morina on 18.02.15.
//  Copyright (c) 2015 SI2. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MFHJSONResponse.h"

@interface MFHUserSettings : MFHJSONResponse

@property NSString *interval;
@property NSString *maxNumberAdverts;
@property NSString *push;

@end
