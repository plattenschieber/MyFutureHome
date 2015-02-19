//
//  MFHJSONResponse.m
//  
//
//  Created by Jeronim Morina on 04.02.15.
//
//

#import "MFHJSONResponse.h"
#import "MFHSession.h"

@implementation MFHJSONResponse

- (id) init
{
    self = [super init];
    if ([MFHSession getCurrentUser])
    {
        self.accessToken = [[MFHSession getCurrentUser] accessToken];
        self.phoneId = [[MFHSession getCurrentUser] phoneId];
    }
    return self;
}
@end
