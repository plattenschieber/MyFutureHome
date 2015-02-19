//
//  MFHUserSearchProfile.m
//  MyFutureHome
//
//  Created by Jeronim Morina on 18.02.15.
//  Copyright (c) 2015 SI2. All rights reserved.
//

#import "MFHUserSearchProfile.h"
#import "MFHSession.h"

@implementation MFHUserSearchProfile

- (id) init
{
    self = [super init];
    
    self.searchProfileId = @"1234";
    self.favoredStreet = @"Peterstr.";
    self.favoredArea = @"NRW";
    self.favoredCity = @"Cologne";
    self.buy = @"No";
    self.price = @"750";
    self.balcony = @"Yes";
    self.size = @"52";
    self.rooms = @"3";
    self.lat = @"30.3";
    self.lng = @"45.4";
    
    return self;
}
@end
