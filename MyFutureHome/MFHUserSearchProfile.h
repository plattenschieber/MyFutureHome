//
//  MFHUserSearchProfile.h
//  MyFutureHome
//
//  Created by Jeronim Morina on 18.02.15.
//  Copyright (c) 2015 SI2. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MFHJSONResponse.h"
#import "MFHAdvert.h"

@interface MFHUserSearchProfile : MFHJSONResponse

@property NSMutableArray *adverts;
@property NSString *als;

@property NSString *searchProfileId;
@property NSString *favoredStreet;
@property NSString *favoredArea;
@property NSString *favoredCity;
@property NSString *buy;
@property NSString *price;
@property NSString *balcony;
@property NSString *size;
@property NSString *rooms;
@property NSString *lat;
@property NSString *lng;

@end
