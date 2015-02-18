//
//  MFHUser.h
//  MyFutureHome
//
//  Created by Jeronim Morina on 18.02.15.
//  Copyright (c) 2015 SI2. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MFHJSONResponse.h"
#import "MFHUserSearchProfile.h"
#import "MFHUserSettings.h"

@interface MFHUser : MFHJSONResponse

@property NSMutableArray* searchProfiles;
@property MFHUserSettings * settings;

@property NSString* phoneId;
@property NSString* accessToken;
@property NSString *firstName;
@property NSString *name;
@property NSString *sex;
@property NSString *job;
@property NSString *birthdate;
@property NSString *postalCode;
@property NSString *children;
@property NSString *city;
@property NSString *email;
@property NSString *emailConfirm;
@property NSString *lat;
@property NSString *lng;
@property NSString *created;

@end
