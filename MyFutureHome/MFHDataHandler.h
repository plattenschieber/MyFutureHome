//
//  MFHDataHandler.h
//  MyFutureHome
//
//  Created by Jeronim Morina on 18.02.15.
//  Copyright (c) 2015 SI2. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>
#import "MFHJSONResponse.h"
#import "MFHUser.h"
#import "MFHUserSearchProfile.h"
#import "MFHAdvert.h"

@interface MFHDataHandler : MFHJSONResponse

@property RKObjectManager *objectManager;
@property RKObjectMapping *responseMapping;
@property RKObjectMapping *requestMapping;
@property RKResponseDescriptor *responseDescriptor;
@property RKRequestDescriptor *requestDescriptor;


//! given a unique phoneId, register this phoneId in the database and return a simple
//! user object with an accessToken
- (void) registerUser: (MFHUser *) user withClass: (Class) objectClass;
//! here we update the user object in our database
- (bool) updateUser: (MFHUser *) user;
//! here we add/update a search profile of a specific user
- (bool) updateUserSearchProfileOfUser: (MFHUser *) user withUserSearchProfile: (MFHUserSearchProfile *) searchProfile;

//! catch all adverts for given searchProfile
- (NSMutableArray *) getCatalogueOfUser: (MFHUser *) user withUserProfile: (MFHUserSearchProfile *) searchProfile;


//! manager methods for configuring the REST calls 
- (void) setupObjectManagerWithRequestClass: (Class) requestClass
                              ResponseClass: (Class) responseClass
                             requestMapping: (NSArray *) requestMapping
                            responseMapping: (NSArray *) responseMapping
                                pathPattern: (NSString *) pathPattern;
- (void) performPOSTRequestWithObject: (NSObject *) postObject
                                 path: (NSString *) path;
- (void) clearObjectManager;

@end
