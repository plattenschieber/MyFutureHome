//
//  MFHDataHandler.m
//  MyFutureHome
//
//  Created by Jeronim Morina on 18.02.15.
//  Copyright (c) 2015 SI2. All rights reserved.
//

#import "MFHDataHandler.h"
#import <RestKit/RestKit.h>
#import "MFHJSONResponseCall.h"
#import "MFHJSONResponseInit.h"
#import "MFHJSONResponseProfile.h"
#import "MFHJSONResponseSettings.h"
#import "MFHJSONResponseUser.h"

@implementation MFHDataHandler


- (id) init
{
    self = [super init];
    [self configureRestKit];
    
    return self;
}

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


- (void)configureRestKit
{
    // initialize AFNetworking HTTPClient
    NSURL *baseURL = [NSURL URLWithString:@"http://myfh.storyspot.de"];
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
    
    // initialize RestKit
    RKObjectManager *objectManager = [[RKObjectManager alloc] initWithHTTPClient:client];
    
    // setup object mappings
    RKObjectMapping *responseMapping = [RKObjectMapping mappingForClass:[MFHJSONResponseInit class]];
    [responseMapping addAttributeMappingsFromArray:@[@"state", @"phoneId", @"accessToken"]];
    
    // register mappings with the provider using a response descriptor
    RKResponseDescriptor *responseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:responseMapping
                                                 method:RKRequestMethodPOST
                                            pathPattern:@"/init"
                                                keyPath:nil
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [objectManager addResponseDescriptor:responseDescriptor];
    
    // setup object mappings
    RKObjectMapping *requestMapping = [RKObjectMapping requestMapping];// Shortcut for [RKObjectMapping mappingForClass:[NSMutableDictionary class] ]
    [requestMapping addAttributeMappingsFromArray:@[@"phoneId"]];
    
    // register mappings with the provider using a response descriptor
    RKRequestDescriptor *requestDescriptor =
    [RKRequestDescriptor
     requestDescriptorWithMapping:requestMapping
     objectClass:[MFHJSONResponseInit class]
     rootKeyPath:nil
     method:RKRequestMethodAny];
    [objectManager addRequestDescriptor:requestDescriptor];
    
    [RKMIMETypeSerialization registerClass:[RKNSJSONSerialization class] forMIMEType:@"text/plain"];
    [objectManager setRequestSerializationMIMEType:RKMIMETypeFormURLEncoded];
}

- (void)loadREST
{
    MFHJSONResponseInit *test = [MFHJSONResponseInit new];
    test.phoneId = [NSString stringWithFormat:@"fbTOKENHERE %i",arc4random_uniform(74)];
    
    [[RKObjectManager sharedManager] postObject:test path:@"init" parameters:nil//queryParams
                                        success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                            NSLog(@"Ballla - Data: %@\tMessage: %@", [test accessToken], [test state]);
                                        }
     
                                        failure:nil];
}



@end
