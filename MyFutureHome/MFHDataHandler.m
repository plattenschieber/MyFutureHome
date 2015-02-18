//
//  MFHDataHandler.m
//  MyFutureHome
//
//  Created by Jeronim Morina on 18.02.15.
//  Copyright (c) 2015 SI2. All rights reserved.
//

#import "MFHDataHandler.h"
#import "MFHJSONResponse.h"

@implementation MFHDataHandler


- (id) init
{
    self = [super init];
    // initialize AFNetworking HTTPClient
    NSURL *baseURL = [NSURL URLWithString:@"http://myfh.storyspot.de"];
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
    
    // initialize RestKit
    self.objectManager = [[RKObjectManager alloc] initWithHTTPClient:client];
    return self;
}

//! given a unique phoneId, register this phoneId in the database and return a simple
//! user object with an accessToken
- (MFHUser *) registerUser: (NSString*) phoneId
{
    // setup object mappings
    RKObjectMapping *responseMapping = [RKObjectMapping mappingForClass:[MFHUser class]];
    [responseMapping addAttributeMappingsFromArray:@[@"state", @"phoneId", @"accessToken"]];
    
    // register mappings with the provider using a response descriptor
    RKResponseDescriptor *responseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:responseMapping
                                                 method:RKRequestMethodPOST
                                            pathPattern:@"/init"
                                                keyPath:nil
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [self.objectManager addResponseDescriptor:responseDescriptor];
    
    // setup object mappings
    RKObjectMapping *requestMapping = [RKObjectMapping requestMapping];// Shortcut for [RKObjectMapping mappingForClass:[NSMutableDictionary class] ]
    [requestMapping addAttributeMappingsFromArray:@[@"phoneId"]];
    
    // register mappings with the provider using a response descriptor
    RKRequestDescriptor *requestDescriptor =
    [RKRequestDescriptor
     requestDescriptorWithMapping:requestMapping
     objectClass:[MFHUser class]
     rootKeyPath:nil
     method:RKRequestMethodAny];
    [self.objectManager addRequestDescriptor:requestDescriptor];
    
    [RKMIMETypeSerialization registerClass:[RKNSJSONSerialization class] forMIMEType:@"text/plain"];
    [self.objectManager setRequestSerializationMIMEType:RKMIMETypeFormURLEncoded];
   
    MFHUser *testUser = [MFHUser new];
    testUser.phoneId = [NSString stringWithFormat:@"%@%i", phoneId, arc4random_uniform(74)];
    NSLog(@"THIS IS THE CURRENT PHONEID: %@",testUser.phoneId);
    
    [[RKObjectManager sharedManager] postObject:testUser path:@"init" parameters:nil//queryParams
                                        success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                            NSLog(@"Ballla - Data: %@\tMessage: %@", [testUser accessToken], [testUser state]);
                                        }
     
                                        failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                            NSLog(@"Ein Satz mit X, das ist der Error: %@", error.description);
                                        }];
    [self.objectManager removeRequestDescriptor:requestDescriptor];
    [self.objectManager removeResponseDescriptor:responseDescriptor];
    
    return testUser;
}
//! here we update the user object in our database
- (bool) updateUser: (MFHUser *) user
{
    return YES;
    
}
//! here we add/update a search profile of a specific user
- (bool) updateUserSearchProfileOfUser: (MFHUser *) user withUserSearchProfile: (MFHUserSearchProfile *) searchProfile
{
    return YES;
}
//! here we add/update the users profile settings
- (bool) updateUserSettingsOfUser: (MFHUser *) user withUserSettings: (MFHUserSettings *) settings
{
    return YES;
}

//! catch all adverts for given searchProfile
- (NSMutableArray *) getCatalogueOfUser: (MFHUser *) user withUserProfile: (MFHUserSearchProfile *) searchProfile
{
    return [NSMutableArray new];
}



@end
