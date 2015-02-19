//
//  MFHDataHandler.m
//  MyFutureHome
//
//  Created by Jeronim Morina on 18.02.15.
//  Copyright (c) 2015 SI2. All rights reserved.
//

#import "MFHDataHandler.h"
#import "MFHJSONResponse.h"
#import "MFHSession.h"

@implementation MFHDataHandler


- (id) init
{
    self = [super init];
    // initialize AFNetworking HTTPClient
    NSURL *baseURL = [NSURL URLWithString:@"http://myfh.storyspot.de"];
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
    
    // initialize RestKit
    self.objectManager = [[RKObjectManager alloc] initWithHTTPClient:client];
    
    // setup the serialization type
    [RKMIMETypeSerialization registerClass:[RKNSJSONSerialization class] forMIMEType:@"text/plain"];
    [self.objectManager setRequestSerializationMIMEType:RKMIMETypeFormURLEncoded];

    return self;
}

//! given a unique phoneId, register this phoneId in the database and return a simple
//! user object with an accessToken
- (void) registerUser: (MFHUser *) user withClass: (Class) objectClass
{
    [self setupObjectManagerWithRequestClass:[MFHUser class]
                               ResponseClass:[MFHUser class]
                              requestMapping:@[@"phoneId"]
                             responseMapping:@[@"state", @"phoneId", @"accessToken"]
                                 pathPattern:@"/init"];
    [self performPOSTRequestWithObject:user path:@"init"];
}


//! here we update the user object in our database
- (bool) updateUser: (MFHUser *) user
{
    [self setupObjectManagerWithRequestClass:[MFHUser class]
                               ResponseClass:[MFHUser class]
                              requestMapping:@[@"phoneId", @"accessToken", @"firstName", @"name", @"sex", @"job", @"birthdate", @"postalCode", @"children", @"city", @"email", @"emailConf", @"lat", @"lng", @"created", @"state", @"errors", @"warnings"]
                             responseMapping:@[@"phoneId",@"accessToken"]
                                 pathPattern:@"/user"];
    [self performPOSTRequestWithObject:user path:@"user"];
}
- (void) setupObjectManagerWithRequestClass: (Class) requestClass
                              ResponseClass: (Class) responseClass
                             requestMapping: (NSArray *) requestMapping
                            responseMapping: (NSArray *) responseMapping
                                pathPattern: (NSString *) pathPattern
{
    // setup response mapping
    self.responseMapping = [RKObjectMapping mappingForClass:responseClass];
    [self.responseMapping addAttributeMappingsFromArray:responseMapping];
    
    // setup request mapping
    self.requestMapping = [RKObjectMapping requestMapping];
    [self.requestMapping addAttributeMappingsFromArray:requestMapping];
    
    // register mappings with the provider using a response descriptor
    self.responseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:self.responseMapping
                                                 method:RKRequestMethodAny
                                            pathPattern:pathPattern
                                                keyPath:nil
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    // register mappings with the provider using a request descriptor
    self.requestDescriptor =
    [RKRequestDescriptor requestDescriptorWithMapping:self.requestMapping
                                          objectClass:requestClass
                                          rootKeyPath:nil
                                               method:RKRequestMethodAny];
    
    // now add all descriptors
    [self.objectManager addResponseDescriptor:self.responseDescriptor];
    [self.objectManager addRequestDescriptor:self.requestDescriptor];

}

- (void) performPOSTRequestWithObject: (NSObject *) postObject
                                 path: (NSString *) path
{
    // actually perform the request and handle the response
    [self.objectManager postObject:postObject path:path parameters:nil//queryParams
                           success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                               NSLog(@"Hat funktioniert, war geil. %@", mappingResult.firstObject);
                               [MFHSession printUser];
                           }
                           failure:^(RKObjectRequestOperation *operation, NSError *error) {
                               NSLog(@"Ein Satz mit X, das ist der Error: %@", error.description);
                           }];
    // and remove the descriptors
    [self clearObjectManager];
}

- (void) clearObjectManager
{
    // clear object manager by removing descriptors
    [self.objectManager removeRequestDescriptor:self.requestDescriptor];
    [self.objectManager removeResponseDescriptor:self.responseDescriptor];
}

//! here we add/update a search profile of a specific user
- (bool) updateUserSearchProfileOfUser: (MFHUser *) user withUserSearchProfile: (MFHUserSearchProfile *) searchProfile
{
    return YES;
}
//! catch all adverts for given searchProfile
- (NSMutableArray *) getCatalogueOfUser: (MFHUser *) user withUserProfile: (MFHUserSearchProfile *) searchProfile
{
    return [NSMutableArray new];
}



@end
