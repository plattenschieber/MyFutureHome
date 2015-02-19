//
//  MFHSession.m
//  MyFutureHome
//
//  Created by Jeronim Morina on 18.02.15.
//  Copyright (c) 2015 SI2. All rights reserved.
//

#import "MFHSession.h"
#import "MFHDataHandler.h"
#import "MFHUserSearchProfile.h"

@implementation MFHSession

static MFHUser* user = nil;
static MFHDataHandler *dataHandler;
static MFHUserSearchProfile *profile;
static int count = 0;

+ (void) start
{
    user = [[MFHUser alloc] init];
    user.phoneId = [NSString stringWithFormat:@"%@%i", @"SUPERMEGAGEILESTOKEN", arc4random_uniform(74)];
    dataHandler = [[MFHDataHandler alloc] init];
    [dataHandler registerUser:user];
    
}

+ (void) printUser
{
    NSLog(@"Und nun sind wir wieder zurück in der Session und geben den AT aus: \n");
    NSLog(@"%@",user.accessToken);
    [self setUserSearchProfile];
}

+ (void) setUserSearchProfile
{
    if (count++ == 0)
        profile = [[MFHUserSearchProfile alloc] init];
    if (count == 1) [dataHandler updateSearchProfile:profile ofUser:user];
    if (count == 2) [dataHandler getCatalogueOfUser:user withSearchProfile:profile];
    
}

+ (void) getCatalogue
{
    [dataHandler getCatalogueOfUser:user withSearchProfile:profile];
}

+ (MFHUser *) getCurrentUser
{
    return user;
}
@end
