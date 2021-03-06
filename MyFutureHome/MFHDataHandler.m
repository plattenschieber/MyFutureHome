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
#import "ALSResponse.h"
#import "ALSPage.h"
#import "ALSPageContent.h"
#import "ALSPageContentPosition.h"
#import "ALSDocumentElement.h"
#import "ALSDocumentElementContent.h"
#import "ALSDocumentElementSubContent.h"

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
    [RKMIMETypeSerialization registerClass:[RKNSJSONSerialization class] forMIMEType:@"text/html"];
    [self.objectManager setRequestSerializationMIMEType:RKMIMETypeFormURLEncoded];

    return self;
}

//! given a unique phoneId, register this phoneId in the database and return a simple
//! user object with an accessToken
- (void) registerUser: (MFHUser *) user
{
    [self setupObjectManagerWithRequestClass:[MFHUser class]
                               ResponseClass:[MFHUser class]
                              requestMapping:@{@"phoneId":@"phoneId"}
                             responseMapping:@{@"phoneId":@"phoneId", @"accessToken":@"accessToken", @"state":@"state", @"errors":@"errors", @"warnings":@"warnings"}
                                 pathPattern:@"/init"];
    [self performPOSTRequestWithObject:user path:@"/init"];
}


//! here we update the user object in our database
- (bool) updateUser: (MFHUser *) user
{
    [self setupObjectManagerWithRequestClass:[MFHUser class]
                               ResponseClass:[MFHUser class]
                              requestMapping:@{@"phoneId":@"phoneId", @"accessToken":@"accessToken", @"firstName":@"firstName", @"name":@"name", @"sex":@"sex", @"job":@"job", @"birthdate":@"birthdate", @"postalCode":@"postalCode", @"children":@"children", @"city":@"city", @"email":@"email", @"emailConf":@"emailConf", @"lat":@"lat", @"lng":@"lng", @"created":@"created", @"state":@"state", @"errors":@"errors", @"warnings":@"warnings"}
                             responseMapping:@{@"phoneId":@"phoneId", @"state":@"state", @"errors":@"errors", @"warnings":@"warnings"}
                                 pathPattern:@"/user"];
    [self performPOSTRequestWithObject:user path:@"/user"];
    return YES;
}
//! here we add/update a search profile of a specific user
- (bool) updateSearchProfile: (MFHUserSearchProfile *) searchProfile ofUser: (MFHUser *) user
{
    [self setupObjectManagerWithRequestClass:[MFHUserSearchProfile class]
                               ResponseClass:[MFHUserSearchProfile class]
                              requestMapping:@{@"phoneId":@"phoneId", @"accessToken":@"accessToken", @"favoredStreet":@"favoredStreet", @"favoredArea":@"favoredArea", @"favoredCity":@"favoredCity", @"buy":@"buy", @"price":@"price", @"balcony":@"balcony", @"size":@"size", @"rooms":@"rooms", @"lat":@"lat", @"lng":@"lng"}
                             responseMapping:@{@"result.profilId":@"searchProfileId", @"state":@"state", @"errors":@"errors", @"warnings":@"warnings"}
                                 pathPattern:@"/profil"];
    [self performPOSTRequestWithObject:searchProfile path:@"/profil"];
    return YES;
}

//! catch all adverts for given searchProfile
- (NSMutableArray *) getCatalogueOfUser: (MFHUser *) user withSearchProfile: (MFHUserSearchProfile *) searchProfile
{
    // setup response mapping
    RKObjectMapping *documentMapping = [RKObjectMapping mappingForClass:[ALSResponse class]];
    [documentMapping addAttributeMappingsFromDictionary:@{@"state":@"state", @"phoneId":@"phoneId"}];
    
    RKObjectMapping *pageMapping = [RKObjectMapping mappingForClass:[ALSPage class]];
    [pageMapping addAttributeMappingsFromDictionary:@{@"height":@"height", @"width":@"width", @"pageNumber":@"pageNumber"}];
    
    RKObjectMapping *pageContentsMapping = [RKObjectMapping mappingForClass:[ALSPageContent class]];
    [pageContentsMapping addAttributeMappingsFromDictionary:@{@"contentType":@"contentType"}];

    RKObjectMapping *pageContentPositionMapping = [RKObjectMapping mappingForClass:[ALSPageContentPosition class]];
    [pageContentPositionMapping addAttributeMappingsFromDictionary:@{@"x":@"x", @"y":@"y", @"width":@"width", @"height":@"height"}];

    RKObjectMapping *documentElementsMapping = [RKObjectMapping mappingForClass:[ALSDocumentElement class]];
    [documentElementsMapping addAttributeMappingsFromDictionary:@{@"class":@"elementClass", @"type":@"elementType", @"text":@"text", @"level":@"level"}];
    
    RKObjectMapping *documentElementsContentMapping = [RKObjectMapping mappingForClass:[ALSDocumentElementContent class]];
    [documentElementsContentMapping addAttributeMappingsFromDictionary:@{@"class":@"elementClass", @"type":@"elementType", @"url":@"url", @"target":@"target"}];
    
    RKObjectMapping *documentElementsSubContentMapping = [RKObjectMapping mappingForClass:[ALSDocumentElementSubContent class]];
    [documentElementsSubContentMapping addAttributeMappingsFromDictionary:@{@"class":@"elementClass", @"type":@"elementType", @"text":@"text", @"style":@"style", @"url":@"url"}];
    
    
    RKRelationshipMapping *pagesRelationship = [RKRelationshipMapping relationshipMappingFromKeyPath:@"alsDocumentPages" toKeyPath:@"pages" withMapping:pageMapping];
    RKRelationshipMapping *pageContentsRelation = [RKRelationshipMapping relationshipMappingFromKeyPath:@"layout.contents" toKeyPath:@"contents" withMapping:pageContentsMapping];
    RKRelationshipMapping *pageContentsPositionRelation = [RKRelationshipMapping relationshipMappingFromKeyPath:@"position" toKeyPath:@"position" withMapping:pageContentPositionMapping];
    RKRelationshipMapping *documentElementsRelation = [RKRelationshipMapping relationshipMappingFromKeyPath:@"documentElements" toKeyPath:@"documentElements" withMapping:documentElementsMapping];
    RKRelationshipMapping *documentElementsContentRelation = [RKRelationshipMapping relationshipMappingFromKeyPath:@"contents" toKeyPath:@"contents" withMapping:documentElementsContentMapping];
    RKRelationshipMapping *documentElementsSubContentRelation = [RKRelationshipMapping relationshipMappingFromKeyPath:@"contents" toKeyPath:@"contents" withMapping:documentElementsSubContentMapping];

    [documentElementsContentMapping addPropertyMapping:documentElementsSubContentRelation];
    [documentElementsMapping addPropertyMapping:documentElementsContentRelation];
    [pageContentsMapping addPropertyMapping:documentElementsRelation];
    [pageContentsMapping addPropertyMapping:pageContentsPositionRelation];
    [pageMapping addPropertyMapping:pageContentsRelation];
    [documentMapping addPropertyMapping:pagesRelationship];
    
    
    RKResponseDescriptor *responseDesc =
    [RKResponseDescriptor responseDescriptorWithMapping:documentMapping
                                                 method:RKRequestMethodAny
                                            pathPattern:@"/call"
                                                keyPath:@"als"
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [self.objectManager addResponseDescriptor:responseDesc];
    
    NSString *width = [NSString stringWithFormat:@"%.0f",[UIScreen mainScreen].bounds.size.width];
    NSString *height = [NSString stringWithFormat:@"%.0f",[UIScreen mainScreen].bounds.size.height];
    NSDictionary *queryParams = @{@"phoneId" : user.phoneId,
                                  @"accessToken" : user.accessToken,
                                  @"width" : width,
                                  @"height" : height,
                                  @"searchProfileId" : [searchProfile searchProfileId]};
    
    [self.objectManager getObjectsAtPath:@"/call"
                              parameters:queryParams
                                 success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                     NSLog(@"(performGETRequestWithPath) Hat funktioniert, war geil. %@", mappingResult.firstObject);
                                     
                                     [MFHSession saveResponse: mappingResult];
                                 }
                                 failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                     NSLog(@"(performGETRequestWithPath) Ein Satz mit X, das ist der Error: %@", error.description);
                                 }];
    // and remove the descriptors
    [self clearObjectManager];

    return [NSMutableArray new];
}

- (void) setupObjectManagerWithRequestClass: (Class) requestClass
                              ResponseClass: (Class) responseClass
                             requestMapping: (NSDictionary *) requestMapping
                            responseMapping: (NSDictionary *) responseMapping
                                pathPattern: (NSString *) pathPattern
{
    // setup response mapping
    self.responseMapping = [RKObjectMapping mappingForClass:responseClass];
    [self.responseMapping addAttributeMappingsFromDictionary:responseMapping];
    
    // setup request mapping
    self.requestMapping = [RKObjectMapping requestMapping];
    [self.requestMapping addAttributeMappingsFromDictionary:requestMapping];
    
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
