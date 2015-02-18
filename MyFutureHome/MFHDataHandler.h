//
//  MFHDataHandler.h
//  MyFutureHome
//
//  Created by Jeronim Morina on 18.02.15.
//  Copyright (c) 2015 SI2. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MFHUser.h"
#import "MFHUserSearchProfile.h"
#import "MFHUserSettings.h"
#import "MFHAdvert.h"

@interface MFHDataHandler : NSObject

//! given a unique phoneId, register this phoneId in the database and return a simple
//! user object with an accessToken
- (MFHUser *) registerUser: (NSString*) phoneId;
//! here we update the user object in our database
- (bool) updateUser: (MFHUser *) user;
//! here we add/update a search profile of a specific user
- (bool) updateUserSearchProfileOfUser: (MFHUser *) user withUserSearchProfile: (MFHUserSearchProfile *) searchProfile;
//! here we add/update the users profile settings
- (bool) updateUserSettingsOfUser: (MFHUser *) user withUserSettings: (MFHUserSettings *) settings;

//! catch all adverts for given searchProfile
- (NSMutableArray *) getCatalogueOfUser: (MFHUser *) user withUserProfile: (MFHUserSearchProfile *) searchProfile;

@end
