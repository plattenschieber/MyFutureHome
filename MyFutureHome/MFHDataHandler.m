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
- (void) registerUser: (MFHUser *) user
{
    [self setupObjectManagerWithRequestClass:[MFHUser class]
                               ResponseClass:[MFHUser class]
                              requestMapping:@[@"phoneId"]
                             responseMapping:@[@"phoneId", @"accessToken", @"state", @"errors", @"warnings"]
                                 pathPattern:@"/init"];
    [self performPOSTRequestWithObject:user path:@"/init"];
}


//! here we update the user object in our database
- (bool) updateUser: (MFHUser *) user
{
    [self setupObjectManagerWithRequestClass:[MFHUser class]
                               ResponseClass:[MFHUser class]
                              requestMapping:@[@"phoneId", @"accessToken", @"firstName", @"name", @"sex", @"job", @"birthdate", @"postalCode", @"children", @"city", @"email", @"emailConf", @"lat", @"lng", @"created", @"state", @"errors", @"warnings"]
                             responseMapping:@[@"phoneId", @"state", @"errors", @"warnings"]
                                 pathPattern:@"/user"];
    [self performPOSTRequestWithObject:user path:@"/user"];
    return YES;
}
//! here we add/update a search profile of a specific user
- (bool) updateSearchProfileOfUser: (MFHUser *) user withUserSearchProfile: (MFHUserSearchProfile *) searchProfile
{
    [self setupObjectManagerWithRequestClass:[MFHUserSearchProfile class]
                               ResponseClass:[MFHUserSearchProfile class]
                              requestMapping:@[@"phoneId", @"accessToken", @"searchProfileId", @"favoredStreet", @"favoredArea", @"favoredCity", @"buy", @"price", @"balcony", @"size", @"rooms", @"lat", @"lng",
                                               @"state", @"errors", @"warnings" ]
                             responseMapping:@[@"searchProfileId"]
                                 pathPattern:@"/profil"];
    [self performPOSTRequestWithObject:user path:@"/profil"];
    return YES;
}

//! catch all adverts for given searchProfile
- (NSMutableArray *) getCatalogueOfUser: (MFHUser *) user withUserProfile: (MFHUserSearchProfile *) searchProfile
{
    [self setupObjectManagerWithRequestClass:nil
                               ResponseClass:[MFHUserSearchProfile class]
                              requestMapping:nil
                             responseMapping:@[@"phoneId", @"als"]
                                 pathPattern:@"/call"];
    
    NSDictionary *queryParams = @{@"phoneId" : user.phoneId,
                                  @"accessToken" : user.accessToken,
                                  @"width" : @"100",
                                  @"height" : @"250",
                                  @"searchProfileId" : [searchProfile searchProfileId]};

    [self performGETRequestWithPath:@"/call" parameters:queryParams];
    return [NSMutableArray new];
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

// actually perform the request and handle the response
- (void) performPOSTRequestWithObject: (NSObject *) postObject
                                 path: (NSString *) path
{
    [self.objectManager postObject:postObject
                              path:path
                        parameters:nil//queryParams
                           success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                               NSLog(@"(performPOSTRequestWithObject) Hat funktioniert, war geil. %@", mappingResult.firstObject);
                               [MFHSession printUser];
                           }
                           failure:^(RKObjectRequestOperation *operation, NSError *error) {
                               NSLog(@"(performPOSTRequestWithObject) Ein Satz mit X, das ist der Error: %@", error.description);
                           }];
    // and remove the descriptors
    [self clearObjectManager];
}
// actually perform the request and handle the response
- (void) performGETRequestWithPath: (NSString *) path
                        parameters: (NSDictionary *) parameters
{
    [self.objectManager getObjectsAtPath:path
                              parameters:parameters
                                 success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                     NSLog(@"(performGETRequestWithPath) Hat funktioniert, war geil. %@", mappingResult.firstObject);
                                     [MFHSession printUser];
                                 }
                                 failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                     NSLog(@"(performGETRequestWithPath) Ein Satz mit X, das ist der Error: %@", error.description);
                                 }];
     // and remove the descriptors
    [self clearObjectManager];
}

//! clear object manager by removing descriptors
- (void) clearObjectManager
{
    [self.objectManager removeRequestDescriptor:self.requestDescriptor];
    [self.objectManager removeResponseDescriptor:self.responseDescriptor];
}


@end
