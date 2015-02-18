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
    // setup response mapping
    RKObjectMapping *responseMapping = [RKObjectMapping mappingForClass:[MFHUser class]];
    [responseMapping addAttributeMappingsFromArray:@[@"state", @"phoneId", @"accessToken"]];
    
    // setup request mapping
    RKObjectMapping *requestMapping = [RKObjectMapping requestMapping];
    [requestMapping addAttributeMappingsFromArray:@[@"phoneId"]];

    // register mappings with the provider using a response descriptor
    RKResponseDescriptor *responseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:responseMapping
                                                 method:RKRequestMethodPOST
                                            pathPattern:@"/init"
                                                keyPath:nil
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    // register mappings with the provider using a request descriptor
    RKRequestDescriptor *requestDescriptor =
    [RKRequestDescriptor requestDescriptorWithMapping:requestMapping
                                          objectClass:[MFHUser class]
                                          rootKeyPath:nil
                                               method:RKRequestMethodAny];
    
    // now add all descriptors
    [self.objectManager addResponseDescriptor:responseDescriptor];
    [self.objectManager addRequestDescriptor:requestDescriptor];
    
    // setup the serialization type
    [RKMIMETypeSerialization registerClass:[RKNSJSONSerialization class] forMIMEType:@"text/plain"];
    [self.objectManager setRequestSerializationMIMEType:RKMIMETypeFormURLEncoded];
   
    // create a new MFHUser object and initialize it
    MFHUser *user = [MFHUser new];
    user.phoneId = [NSString stringWithFormat:@"%@%i", phoneId, arc4random_uniform(74)];
    
    // actually perform the request and handle the response
    [[RKObjectManager sharedManager] postObject:user path:@"init" parameters:nil//queryParams
                                        success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                            NSLog(@"Ballla - Data: %@\tMessage: %@", [user accessToken], [user state]);
                                        }
     
                                        failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                            NSLog(@"Ein Satz mit X, das ist der Error: %@", error.description);
                                        }];
    
    // clear object manager by removing descriptors
    [self.objectManager removeRequestDescriptor:requestDescriptor];
    [self.objectManager removeResponseDescriptor:responseDescriptor];
    
    return user;
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
