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
    self.favoredStreet = @"Zülpicher Str. 12";
    self.favoredArea = @"NRW";
    self.favoredCity = @"Köln Innenstadt";
    self.buy = nil;
    self.price = @"1500";
    self.balcony = @"Y";
    self.size = @"52";
    self.rooms = @"3";
    self.lat = @"50.9295283";
    self.lng = @"6.9379229";
    
    return self;
}
@end
