//
//  MFHSession.m
//  MyFutureHome
//
//  Created by Jeronim Morina on 18.02.15.
//  Copyright (c) 2015 SI2. All rights reserved.
//

#import "MFHSession.h"
#import "MFHDataHandler.h"

@implementation MFHSession

static MFHUser* user = nil;
static MFHDataHandler *dataHandler;

+ (void) start
{
    user = [[MFHUser alloc] init];
    user.phoneId = [NSString stringWithFormat:@"%@%i", @"SUPERMEGAGEILESTOKEN", arc4random_uniform(74)];
    MFHDataHandler *dataHandler = [[MFHDataHandler alloc] init];
    [dataHandler registerUser:user withClass:[MFHUser class]];
}

+ (void) printUser
{
    NSLog(@"Und nun sind wir wieder zurück in der Session und geben den AT aus: \n");
    NSLog(@"%@",user.accessToken);
}

+ (MFHUser *) getCurrentUser
{
    return user;
}
@end
